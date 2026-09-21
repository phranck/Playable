// @ts-check
import node from "@astrojs/node";
import { defineConfig } from "astro/config";

// Server rendered rather than static. The live overview is only worth looking
// at whilst it is current, and a share link has to answer for a channel that
// did not exist when the site was built.
export default defineConfig({
  output: "server",
  adapter: node({ mode: "standalone" }),
  server: { host: true },
});
