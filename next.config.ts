import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // The MVP site is one static HTML file: serve it at the root address.
  async rewrites() {
    return {
      beforeFiles: [{ source: "/", destination: "/project-portfolio.html" }],
      afterFiles: [],
      fallback: [],
    };
  },
  cacheComponents: true,
  partialPrefetching: true,
  turbopack: {
    rules: {
      "*.css": {
        loaders: ["@tailwindcss/turbopack"],
        as: "*.css",
      },
    },
  },
};

export default nextConfig;
