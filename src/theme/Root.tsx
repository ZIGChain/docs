import React, { useEffect, useRef } from "react";
import { useLocation } from "@docusaurus/router";
import Intercom from "@intercom/messenger-js-sdk";

const INTERCOM_APP_ID = "cqbx87vv";
const INTERCOM_API_BASE = "https://api-iam.intercom.io";

export default function Root({
  children,
}: {
  children: React.ReactNode;
}): JSX.Element {
  const location = useLocation();
  const hasMountedRef = useRef(false);

  useEffect(() => {
    if (!hasMountedRef.current) {
      // Initialize Intercom
      Intercom({
        app_id: INTERCOM_APP_ID,
        api_base: INTERCOM_API_BASE,
      });
      hasMountedRef.current = true;
    } else if (typeof (window as any)?.Intercom === "function") {
      // Trigger Intercom update on route change
      const lastRequestAt = Math.floor(Date.now() / 1000);
      (window as any).Intercom("update", { last_request_at: lastRequestAt });
    }
  }, [location.pathname]);

  return <>{children}</>;
}
