import express from "express";
import cors from "cors";
import fetch from "node-fetch";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";
import https from "https";


const app = express();
const PORT = 5000;

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

app.use(cors());
app.use(express.json());

app.use(express.static(path.join(__dirname, "public")));

app.post("/api/translate", async (req, res) => {
  const { text, direction } = req.body;

  if (!text || !direction) {
    return res.status(400).json({ error: "Missing text or direction" });
  }

  const prompt = direction === "toPlain"
    ? `Act as a professional translator. Translate the following from Gen Z slang to plain English only. No explanations.\n\n${text}`
    : `Act as a professional translator. Translate the following from plain English to Gen Z slang only. No explanations.\n\n${text}`;

  try {
    const aiResponse = await fetch("http://127.0.0.1:11434/api/generate",
 {
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

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "public", "new.html"));
});

const key = fs.readFileSync("./cert/localhost/localhost.decrypted.key");
const cert = fs.readFileSync("./cert/localhost/localhost.crt");

https.createServer({ key, cert }, app).listen(PORT, "0.0.0.0", () => {
  console.log(`✅ HTTPS Server running at https://0.0.0.0:${PORT}`);
});
