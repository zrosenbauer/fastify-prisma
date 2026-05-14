import tsconfigPaths from "vite-tsconfig-paths";
import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: true,
    environment: "node",
    coverage: {
      provider: "istanbul",
      reporter: ["text", "json", "json-summary", "html"],
      all: true,
    },
    testTimeout: 15000,
  },
  // oxlint-disable-next-line no-explicit-any -- TS type depth exceeded on the plugin result
  plugins: [tsconfigPaths() as any],
});
