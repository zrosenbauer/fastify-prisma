import path from "node:path";
import { defineConfig } from "prisma/config";

export default defineConfig({
  earlyAccess: true,
  schema: path.join(__dirname, "schema.prisma"),
  migrate: {
    adapter: async () => {
      const { PrismaBetterSqlite3 } = await import("@prisma/adapter-better-sqlite3");
      const Database = (await import("better-sqlite3")).default;
      const database = new Database(path.join(__dirname, "faux.db"));
      return new PrismaBetterSqlite3(database);
    },
  },
});
