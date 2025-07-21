import express from "express";
import cors from "cors";
import fetch from "node-fetch";
import fs from "fs";
import path from "path";
import bcrypt from 'bcrypt';
import { fileURLToPath } from "url";
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = 5000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const HUGGINGFACE_API_KEY = process.env.HUGGINGFACE_API_KEY;

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.post("/api/translate", async (req, res) => {
  const { text, direction } = req.body;

  if (!text || !direction) {
    return res.status(400).json({ error: "Missing text or direction" });
  }

  const prompt = direction === "toPlain"
    ? `Translate the following from Gen Z slang to plain English:\n\n${text}`
    : `Translate the following from plain English to Gen Z slang:\n\n${text}`;

  try {
    const aiResponse = await fetch("http://localhost:11434/api/chat", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "llama3",
        messages: [{ role: "user", content: prompt }]
      })
    });


    const aiData = await aiResponse.json();

    console.log("AI response:", aiData);

    const result = aiData?.[0]?.generated_text?.replace(prompt, '').trim();
    if (!result) {
      return res.status(500).json({ error: "No valid response from Hugging Face" });
    }

    res.json({ translatedText: result });
  } catch (err) {
    console.error("Backend error:", err.message);
    res.status(500).json({ error: "Translation failed" });
  }
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "new.html"));
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
