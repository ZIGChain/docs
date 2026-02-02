import React, { useMemo } from "react";

export const ZigchainAddressAvatar = React.memo(({
  address,
  className,
}: {
  address: string;
  className: string;
}) => {
  // Memoize gradient color calculation to avoid expensive recomputation on every render
  // This is especially important on mobile devices with slower CPUs
  const colors = useMemo(() => {
    // Remove any common prefix (like "cosmos1") to focus on the hash part of the address
    const cleanAddress = address.replace(/^[a-z0-9]+1/, "");
    // Attempt to evenly divide the address into segments
    const segmentLength = Math.ceil(cleanAddress.length / 5);
    const regexPattern = new RegExp(`.{1,${segmentLength}}`, "g");
    const seedArr = cleanAddress.match(regexPattern)?.splice(0, 5);
    const computedColors: string[] = [];

    seedArr?.forEach((seed) => {
      let hash = 0;
      for (let i = 0; i < seed.length; i++) {
        hash = seed.charCodeAt(i) + ((hash << 5) - hash);
        hash = hash & hash; // Convert to 32bit integer
      }

      const rgb = [0, 0, 0];
      for (let i = 0; i < 3; i++) {
        const value = (hash >> (i * 8)) & 255;
        rgb[i] = value;
      }
      computedColors.push(`rgb(${rgb[0]}, ${rgb[1]}, ${rgb[2]})`);
    });

    return computedColors;
  }, [address]);

  const backgroundStyle = useMemo(() => ({
    width: "40px",
    height: "40px",
    borderRadius: "50%",
    boxShadow: "inset 0 0 0 1px rgba(0, 0, 0, 0.1)",
    backgroundColor: colors[0],
    backgroundImage: `
      radial-gradient(at 66% 77%, ${colors[1]} 0px, transparent 50%),
      radial-gradient(at 29% 97%, ${colors[2]} 0px, transparent 50%),
      radial-gradient(at 99% 86%, ${colors[3]} 0px, transparent 50%),
      radial-gradient(at 29% 88%, ${colors[4]} 0px, transparent 50%)
    `,
  }), [colors]);

  return <div className={className} style={backgroundStyle}></div>;
});
