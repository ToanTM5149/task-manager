import express from "express";
import cors from "cors";
import authRouter from "./routes/auth";
import taskRouter from "./routes/task";
import migrateDb from "./db/migrations";

const app = express();

app.use(cors({
  origin: true, 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'x-auth-token'],
  credentials: true
}));

app.use(express.json());
app.use("/auth", authRouter);
app.use("/tasks", taskRouter);

app.get("/", (req, res) => {
  res.send("Welcome to my app!!!!!!!");
});

migrateDb().then(() => {
  app.listen(8000, () => {
    console.log("Server started on port 8000");
  });
});
