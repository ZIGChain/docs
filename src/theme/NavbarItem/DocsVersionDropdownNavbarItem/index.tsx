/**
 * Swizzled DocsVersionDropdownNavbarItem: when switching versions, redirect to
 * the equivalent page when possible (same doc ID or version-specific path mapping).
 * - v1/v0 → v2: REDIRECT_MAP when no same-ID alternate
 * - v2 → v1/v0: REVERSE_REDIRECT_MAP[version.name] when no same-ID alternate
 */

import React from "react";
import {
  useVersions,
  useActiveDocContext,
  useDocsVersionCandidates,
  useDocsPreferredVersion,
  useActiveVersion,
} from "@docusaurus/plugin-content-docs/client";
import { translate } from "@docusaurus/Translate";
import { useLocation } from "@docusaurus/router";
import DefaultNavbarItem from "@theme/NavbarItem/DefaultNavbarItem";
import DropdownNavbarItem from "@theme/NavbarItem/DropdownNavbarItem";
import type { Props } from "@theme/NavbarItem/DocsVersionDropdownNavbarItem";
import type { LinkLikeNavbarItemProps } from "@theme/NavbarItem";
import type {
  GlobalVersion,
  GlobalDoc,
  ActiveDocContext,
} from "@docusaurus/plugin-content-docs/client";
import {
  REDIRECT_MAP,
  REDIRECT_ENTRIES,
  REVERSE_REDIRECT_MAP,
  REVERSE_REDIRECT_MAP_LIST,
} from "../../../../redirects.config";

function getVersionMainDoc(version: GlobalVersion): GlobalDoc {
  return version.docs.find((doc) => doc.id === version.mainDocId)!;
}

function getVersionTargetDoc(
  version: GlobalVersion,
  activeDocContext: ActiveDocContext
): GlobalDoc {
  return (
    activeDocContext.alternateDocVersions[version.name] ??
    getVersionMainDoc(version)
  );
}

function getPathWithoutVersion(
  pathname: string,
  versionPath: string | undefined
): string {
  if (!versionPath) return pathname;
  return pathname.startsWith(versionPath)
    ? pathname.slice(versionPath.length) || "/"
    : pathname;
}

/** Trim trailing slash for comparison. "/foo/" -> "/foo" */
function trimTrailingSlash(p: string): string {
  return p.endsWith("/") && p.length > 1 ? p.slice(0, -1) : p;
}

function pathEq(a: string, b: string): boolean {
  return trimTrailingSlash(a) === trimTrailingSlash(b);
}

/** Version base path from main doc. "/v1/intro" -> "/v1" */
function getVersionBasePath(version: GlobalVersion): string {
  const mainPath = getVersionMainDoc(version).path;
  const lastSlash = mainPath.lastIndexOf("/");
  return lastSlash <= 0 ? "/" : mainPath.slice(0, lastSlash);
}

/** Find equivalent path in target version. Returns null if none. Tries all "from" alternates so v0↔v1 path differences work. */
function findEquivalentPath(
  version: GlobalVersion,
  currentPath: string
): string | null {
  const base = version.path.startsWith("/") ? version.path : `/${version.path}`;
  for (const { from, to } of REDIRECT_ENTRIES) {
    if (!pathEq(currentPath, from) && !pathEq(currentPath, to)) continue;
    const toKey = trimTrailingSlash(to);
    const fromPaths = REVERSE_REDIRECT_MAP_LIST[toKey];
    if (fromPaths?.length) {
      for (const fromPath of fromPaths) {
        const suffix = fromPath.startsWith("/") ? fromPath : `/${fromPath}`;
        const fullPath = `${base}${suffix}`;
        if (pathExistsInVersion(version, fullPath)) return fullPath;
      }
    } else {
      const suffix = from.startsWith("/") ? from : `/${from}`;
      const fullPath = `${base}${suffix}`;
      if (pathExistsInVersion(version, fullPath)) return fullPath;
    }
  }
  return null;
}

/** When on v2, get v0/v1 path for the same page. Tries all "from" alternates (v0 and v1 can use different paths). */
function getOldVersionPathFromV2(
  v2Pathname: string,
  versionBasePath: string,
  version: GlobalVersion
): string | null {
  const normalized = trimTrailingSlash(v2Pathname);
  const fromPaths = REVERSE_REDIRECT_MAP_LIST[normalized];
  if (!fromPaths?.length) return null;
  const base = versionBasePath.startsWith("/")
    ? versionBasePath
    : `/${versionBasePath}`;
  for (const fromPath of fromPaths) {
    const suffix = fromPath.startsWith("/") ? fromPath : `/${fromPath}`;
    const candidate = `${base}${suffix}`;
    if (pathExistsInVersion(version, candidate)) return candidate;
  }
  return null;
}

/** True if the version has a doc at this path (avoids broken links when v0/v1 lack some docs). */
function pathExistsInVersion(
  version: GlobalVersion,
  candidatePath: string
): boolean {
  return version.docs.some((doc) => pathEq(doc.path, candidatePath));
}

export default function DocsVersionDropdownNavbarItem({
  mobile,
  docsPluginId,
  dropdownActiveClassDisabled,
  dropdownItemsBefore,
  dropdownItemsAfter,
  ...props
}: Props): JSX.Element {
  const { pathname, search, hash } = useLocation();
  const activeDocContext = useActiveDocContext(docsPluginId);
  const activeVersion = useActiveVersion(docsPluginId);
  const versions = useVersions(docsPluginId);
  const { savePreferredVersionName } = useDocsPreferredVersion(docsPluginId);

  function versionToLink(version: GlobalVersion): LinkLikeNavbarItemProps {
    const targetDoc = getVersionTargetDoc(version, activeDocContext);
    let targetPath = targetDoc.path;
    const hasAlternate = !!activeDocContext.alternateDocVersions[version.name];

    if (version.isLast) {
      // Switching to v2: use REDIRECT_MAP when no same-ID alternate
      if (!hasAlternate && activeVersion) {
        const pathWithoutVersion = getPathWithoutVersion(
          pathname,
          activeVersion.path
        );
        const mappedPath = REDIRECT_MAP[pathWithoutVersion];
        if (mappedPath) targetPath = mappedPath;
      }
    } else if (!hasAlternate) {
      // Strip version prefix so we get the logical path (e.g. /general/staking) for redirect lookup.
      // version.path is "/v0" or "/v1", so getPathWithoutVersion does the right strip.
      let currentPath =
        getPathWithoutVersion(pathname, activeVersion?.path) || "/";
      if (currentPath && !currentPath.startsWith("/"))
        currentPath = "/" + currentPath;
      let equivalent = findEquivalentPath(version, currentPath);
      if (!equivalent && activeVersion?.isLast) {
        equivalent = getOldVersionPathFromV2(
          pathname,
          getVersionBasePath(version),
          version
        );
      }
      if (equivalent && pathExistsInVersion(version, equivalent)) {
        targetPath = equivalent;
      }
    }

    return {
      label: version.label,
      to: `${targetPath}${search}${hash}`,
      isActive: () => version === activeDocContext.activeVersion,
      onClick: () => savePreferredVersionName(version.name),
    };
  }

  const items: LinkLikeNavbarItemProps[] = [
    ...dropdownItemsBefore,
    ...versions.map(versionToLink),
    ...dropdownItemsAfter,
  ];

  const dropdownVersion = useDocsVersionCandidates(docsPluginId)[0];
  const defaultTargetDoc = getVersionTargetDoc(
    dropdownVersion,
    activeDocContext
  );
  let dropdownTo = defaultTargetDoc.path;

  if (dropdownVersion.isLast) {
    // Switching to v2: use REDIRECT_MAP when no same-ID alternate
    if (
      !activeDocContext.alternateDocVersions[dropdownVersion.name] &&
      activeVersion
    ) {
      const pathWithoutVersion = getPathWithoutVersion(
        pathname,
        activeVersion.path
      );
      const mappedPath = REDIRECT_MAP[pathWithoutVersion];
      if (mappedPath) dropdownTo = mappedPath;
    }
  } else if (
    activeVersion?.isLast &&
    !activeDocContext.alternateDocVersions[dropdownVersion.name]
  ) {
    // On v2, dropdown showing v0/v1: try all "from" alternates so v0 vs v1 path differences work
    const equivalent = getOldVersionPathFromV2(
      pathname,
      getVersionBasePath(dropdownVersion),
      dropdownVersion
    );
    if (equivalent) dropdownTo = equivalent;
  }

  const dropdownLabel =
    mobile && items.length > 1
      ? translate({
          id: "theme.navbar.mobileVersionsDropdown.label",
          message: "Versions",
          description:
            "The label for the navbar versions dropdown on mobile view",
        })
      : dropdownVersion.label;

  if (items.length <= 1) {
    return (
      <DefaultNavbarItem
        {...props}
        mobile={mobile}
        label={dropdownLabel}
        to={mobile && items.length > 1 ? undefined : dropdownTo}
        isActive={dropdownActiveClassDisabled ? () => false : undefined}
      />
    );
  }

  return (
    <DropdownNavbarItem
      {...props}
      mobile={mobile}
      label={dropdownLabel}
      to={mobile ? undefined : dropdownTo}
      items={items}
      isActive={dropdownActiveClassDisabled ? () => false : undefined}
    />
  );
}
