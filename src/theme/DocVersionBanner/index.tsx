/**
 * Swizzled DocVersionBanner: "latest version" link points to the equivalent
 * current doc when content moved (e.g. v1 general/zig → about-zigchain/zig).
 * Falls back to default (main doc) when no mapping exists.
 */

import React from "react";
import clsx from "clsx";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Link from "@docusaurus/Link";
import Translate from "@docusaurus/Translate";
import { useLocation } from "@docusaurus/router";
import {
  useActivePlugin,
  useDocVersionSuggestions,
  type GlobalVersion,
} from "@docusaurus/plugin-content-docs/client";
import { ThemeClassNames } from "@docusaurus/theme-common";
import {
  useActiveVersion,
  useDocsPreferredVersion,
  useDocsVersion,
} from "@docusaurus/plugin-content-docs/client";
import type {
  VersionBanner,
  PropVersionMetadata,
} from "@docusaurus/plugin-content-docs";
import { REDIRECT_MAP } from "../../../redirects.config";

type Props = { className?: string };

type BannerLabelComponentProps = {
  siteTitle: string;
  versionMetadata: PropVersionMetadata;
};

function UnreleasedVersionLabel({
  siteTitle,
  versionMetadata,
}: BannerLabelComponentProps) {
  return (
    <Translate
      id="theme.docs.versions.unreleasedVersionLabel"
      values={{
        siteTitle,
        versionLabel: <b>{versionMetadata.label}</b>,
      }}
    >
      {
        "This is unreleased documentation for {siteTitle} {versionLabel} version."
      }
    </Translate>
  );
}

function UnmaintainedVersionLabel({
  siteTitle,
  versionMetadata,
}: BannerLabelComponentProps) {
  return (
    <Translate
      id="theme.docs.versions.unmaintainedVersionLabel"
      values={{
        siteTitle,
        versionLabel: <b>{versionMetadata.label}</b>,
      }}
    >
      {
        "This is documentation for {siteTitle} {versionLabel}, which is no longer actively maintained."
      }
    </Translate>
  );
}

const BannerLabelComponents: {
  [banner in VersionBanner]: React.ComponentType<BannerLabelComponentProps>;
} = {
  unreleased: UnreleasedVersionLabel,
  unmaintained: UnmaintainedVersionLabel,
};

function BannerLabel(props: BannerLabelComponentProps) {
  const BannerLabelComponent =
    BannerLabelComponents[props.versionMetadata.banner!];
  return <BannerLabelComponent {...props} />;
}

function LatestVersionSuggestionLabel({
  versionLabel,
  to,
  onClick,
}: {
  to: string;
  onClick: () => void;
  versionLabel: string;
}) {
  return (
    <Translate
      id="theme.docs.versions.latestVersionSuggestionLabel"
      values={{
        versionLabel,
        latestVersionLink: (
          <b>
            <Link to={to} onClick={onClick}>
              <Translate id="theme.docs.versions.latestVersionLinkLabel">
                latest version
              </Translate>
            </Link>
          </b>
        ),
      }}
    >
      {
        "For up-to-date documentation, see the {latestVersionLink} ({versionLabel})."
      }
    </Translate>
  );
}

function DocVersionBannerEnabled({
  className,
  versionMetadata,
}: Props & {
  versionMetadata: PropVersionMetadata;
}): JSX.Element {
  const {
    siteConfig: { title: siteTitle },
  } = useDocusaurusContext();
  const { pluginId } = useActivePlugin({ failfast: true })!;
  const location = useLocation();

  const getVersionMainDoc = (version: GlobalVersion) =>
    version.docs.find((doc) => doc.id === version.mainDocId)!;

  const { savePreferredVersionName } = useDocsPreferredVersion(pluginId);

  const { latestDocSuggestion, latestVersionSuggestion } =
    useDocVersionSuggestions(pluginId);
  const activeVersion = useActiveVersion(pluginId);

  // Prefer same doc (alternate) when it exists; else REDIRECT_MAP when content moved
  let latestVersionPath: string;
  if (latestDocSuggestion) {
    latestVersionPath = latestDocSuggestion.path;
  } else {
    const activeVersionPath = activeVersion?.path ?? "";
    const pathWithoutVersion =
      activeVersionPath && location.pathname.startsWith(activeVersionPath)
        ? location.pathname.slice(activeVersionPath.length) || "/"
        : location.pathname;
    const mappedPath = REDIRECT_MAP[pathWithoutVersion];
    latestVersionPath =
      mappedPath ?? getVersionMainDoc(latestVersionSuggestion).path;
  }

  return (
    <div
      className={clsx(
        className,
        ThemeClassNames.docs.docVersionBanner,
        "alert alert--warning margin-bottom--md",
      )}
      role="alert"
    >
      <div>
        <BannerLabel siteTitle={siteTitle} versionMetadata={versionMetadata} />
      </div>
      <div className="margin-top--md">
        <LatestVersionSuggestionLabel
          versionLabel={latestVersionSuggestion.label}
          to={latestVersionPath}
          onClick={() => savePreferredVersionName(latestVersionSuggestion.name)}
        />
      </div>
    </div>
  );
}

export default function DocVersionBanner({
  className,
}: Props): JSX.Element | null {
  const versionMetadata = useDocsVersion();
  if (versionMetadata.banner) {
    return (
      <DocVersionBannerEnabled
        className={className}
        versionMetadata={versionMetadata}
      />
    );
  }
  return null;
}
