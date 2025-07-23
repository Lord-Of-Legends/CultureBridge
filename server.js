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

  console.log("🔁 /api/translate called with:", { text, direction });

  if (!text || !direction) {
    console.error("❌ Missing text or direction");
    return res.status(400).json({ error: "Missing text or direction" });
  }

  const prompt = direction === "toPlain"
    ? `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from Gen Z slang to plain English only. Translate: "\n\n${text}"`
    : `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from plain English to Gen Z slang only. Translate: "\n\n${text}"`;

  try {
    console.log("🧠 Sending request to Ollama...");
    const aiResponse = await fetch("http://localhost:11434/api/generate", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "llama2-uncensored",
        prompt: prompt,
        stream: false,
      }),
    });

    if (!aiResponse.ok) {
      const errText = await aiResponse.text();
      console.error("❌ Ollama error response:", errText);
      return res.status(500).json({ error: "Ollama responded with error" });
    }

    const aiData = await aiResponse.json();
    console.log("✅ Ollama returned:", aiData);

    if (!aiData || !aiData.response) {
      console.error("❌ Ollama response missing 'response' field");
      return res.status(500).json({ error: "Incomplete response from Ollama" });
    }

    res.json({ translatedText: aiData.response.trim() });
  } catch (err) {
    console.error("❌ Backend error:", err.message, err);
    res.status(500).json({ error: "Translation failed due to backend issue" });
  }
});

app.get("/health", (req, res) => {
  console.log("💓 /health check");
  res.send("OK");
});

app.get("/test", (req, res) => {
  console.log("🧪 /test endpoint hit");
  res.json({ message: "Server and Express are working!" });
});

app.get("/", (req, res) => {
  console.log("📄 Serving new.html...");
  res.sendFile(path.join(__dirname, "public", "new.html"));
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://0.0.0.0:${PORT}`);
});
