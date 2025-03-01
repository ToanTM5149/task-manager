import type { Config } from "drizzle-kit";

export default {
  schema: "./src/db/schema.ts",
  out: "./drizzle",
  dialect: "postgresql",
  dbCredentials: {
    host: "db",
    port: 5432,
    database: "mydb",
    user: "postgres",
    password: "test123"
  }
} satisfies Config;