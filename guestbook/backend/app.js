const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
app.use(cors());
app.use(express.json());

// These come from docker-compose.yml env vars
const pool = new Pool({
  host: process.env.DBHOST || "db",
  user: process.env.DBUSER || "dbuser",
  password: process.env.DBPASSWORD || "dbpassword",
  database: process.env.DBDATABASE || "dbname",
  port: Number(process.env.DBPORT || 5432),
});

app.get("/health", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.send("ok");
  } catch (e) {
    res.status(500).send("db not ready");
  }
});

// List entries (newest first)
app.get("/api/entries", async (req, res) => {
  const { rows } = await pool.query(
    "SELECT id, name, message, created_at FROM entries ORDER BY created_at DESC LIMIT 50"
  );
  res.json(rows);
});

// Add entry
app.post("/api/entries", async (req, res) => {
  const name = String(req.body?.name || "").trim();
  const message = String(req.body?.message || "").trim();

  if (!name || !message) {
    return res.status(400).json({ error: "name and message are required" });
  }

  const { rows } = await pool.query(
    "INSERT INTO entries (name, message) VALUES ($1, $2) RETURNING id, name, message, created_at",
    [name, message]
  );

  res.status(201).json(rows[0]);
});

const port = 5000;
app.listen(port, () => console.log(`Backend listening on ${port}`));