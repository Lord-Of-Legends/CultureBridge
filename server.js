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

const apiKey = process.env.OPENROUTER_API_KEY;

app.use(cors());
app.use(express.json());
app.use(express.static('public'));

app.post("https://culturebridge.onrender.com/api/translate", async (req, res) => {
  const { text, direction } = req.body;

  if (!text || !direction) {
    return res.status(400).json({ error: "Missing text or direction" });
  }

  const prompt = direction === "toPlain"
    ? `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from Gen Z slang to plain English only. Translate: "\n\n${text}"`
    : `You are a translator for Gen Z language and you can translate to and from Gen Z to normal English. Act as a translator for future prompts and do not break character. Do not say any other thing apart from the translated sentence. No personal input. Translate the following from plain English to Gen Z slang only. Translate: "\n\n${text}"`;

  try {
    const aiResponse = await fetch("https://openrouter.ai/api/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${apiKey}"
      },
      body: JSON.stringify({
        model: "deepseek/deepseek-chat-v3-0324:free",
        messages: [{ role: "user", content: prompt }],
        temperature: 0.7
      })
    });

    const aiData = await aiResponse.json();

    console.log("AI response:", aiData);

    const result = aiData?.choices?.[0]?.message?.content?.trim();
    if (!result) {
      return res.status(500).json({ error: "No valid response from AI" });
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
  console.log(`Server running at http://0.0.0.0:${PORT}`);
});
