import express from "express";
import cors from "cors";
import fetch from "node-fetch";
import fs from "fs";
import path from "path";
import bcrypt from "bcrypt";
import { fileURLToPath } from "url";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(cors());
app.use(express.json());
app.use(express.static("public"));

app.post("/api/translate", async (req, res) => {
  const { text, direction } = req.body;

  if (!text || !direction) {
    return res.status(400).json({ error: "Missing text or direction" });
  }

  const prompt = direction === "toPlain"
    ? `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from Gen Z slang to plain English only. Translate: "\n\n${text}"`
    : `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from plain English to Gen Z slang only. Translate: "\n\n${text}"`;

  try {
    const aiResponse = await fetch("http://localhost:11434/api/generate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "llama2-uncensored",
        prompt: prompt,
        stream: false,
      }),
    });

    const aiData = await aiResponse.json();
    res.json({ translatedText: aiData.response.trim() });
  } catch (err) {
    console.error("Backend error:", err.message);
    res.status(500).json({ error: "Translation failed" });
  }
});

app.get("/health", (req, res) => {
  res.send("OK");
});

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "new.html"));
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
