import { migrate } from "drizzle-orm/node-postgres/migrator";
import { db } from "./index";

// Tự động chạy các migrations cần thiết trên database
const migrateDb = async () => {
  try {
    await migrate(db, { migrationsFolder: "drizzle" });
    console.log("Migration hoàn tất thành công");
  } catch (error) {
    console.error("Lỗi trong quá trình migration:", error);
  }
};

export default migrateDb; 