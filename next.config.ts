import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // The plans page was replaced by the splash site (design/splash-handoff); old links land on the home page.
  async redirects() {
    return [{ source: '/pricing', destination: '/', permanent: true }];
  },
};

export default nextConfig;
