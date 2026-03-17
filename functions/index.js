const { onRequest } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const { GoogleGenerativeAI } = require("@google/generative-ai");

// Definição da chave segura que será gravada no Secret Manager do Google
const geminiApiKey = defineSecret("GEMINI_API_KEY");

exports.analyzeMeal = onRequest(
  {
    secrets: [geminiApiKey],
    cors: true,
    invoker: "public",
  },
  async (req, res) => {
    if (req.method !== "POST") {
      return res.status(405).send("Method Not Allowed");
    }

    const { prompt } = req.body;
    if (!prompt) {
      return res.status(400).send("Prompt is required");
    }

    try {
      const genAI = new GoogleGenerativeAI(geminiApiKey.value());
      const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

      const structuredPrompt = `
      Atue como um nutricionista. O usuário comeu o seguinte: "${prompt}".
      Calcule as calorias e os macronutrientes aproximados.
      Retorne APENAS um JSON válido com esta estrutura exata (use números inteiros):
      {"kcal": 0, "protein": 0, "carbo": 0, "fat": 0}
      Não adicione crases, blocos de código, nem texto explicativo. Apenas o JSON puro.
      `;

      const response = await model.generateContent(structuredPrompt);
      const text = response.response.text();

      const cleanText = text.replace(/```json/g, '').replace(/```/g, '').trim();
      const data = JSON.parse(cleanText);

      return res.status(200).json(data);
      
    } catch (error) {
      console.error("Erro no Gemini proxy:", error);
      return res.status(500).json({ error: "Failed to analyze meal" });
    }
  }
);
