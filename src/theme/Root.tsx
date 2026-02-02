import React, { useEffect } from "react";

export default function Root({
  children,
}: {
  children: React.ReactNode;
}): JSX.Element {
  // Add Font Awesome preconnect and async loading for better mobile performance
  useEffect(() => {
    if (typeof document !== "undefined") {
      // Add preconnect for Font Awesome CDN
      const preconnect = document.createElement("link");
      preconnect.rel = "preconnect";
      preconnect.href = "https://cdnjs.cloudflare.com";
      preconnect.crossOrigin = "anonymous";

      // Check if preconnect already exists
      if (
        !document.querySelector('link[href="https://cdnjs.cloudflare.com"]')
      ) {
        document.head.appendChild(preconnect);
      }

      // Load Font Awesome asynchronously to prevent blocking CSS parsing
      const fontAwesomeLink = document.createElement("link");
      fontAwesomeLink.rel = "stylesheet";
      fontAwesomeLink.href =
        "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css";
      fontAwesomeLink.media = "print";
      fontAwesomeLink.onload = () => {
        fontAwesomeLink.media = "all";
      };

      // Check if Font Awesome already exists
      if (!document.querySelector('link[href*="font-awesome"]')) {
        document.head.appendChild(fontAwesomeLink);
      }
    }
  }, []);

  return <>{children}</>;
}
