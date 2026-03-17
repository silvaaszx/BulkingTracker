# 🏋️‍♂️ BulkingTracker

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%23Gemini-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)

Um aplicativo mobile de alto desempenho projetado para rastreamento inteligente de ganho de massa muscular (Bulking). Diferente dos contadores de calorias tradicionais, o BulkingTracker utiliza a IA do Google Gemini para interpretar refeições em linguagem natural, além de contar com um sistema de gamificação e interface UI/UX premium.

> **📱 Nota UI/UX:** Interface construída com conceitos avançados de Glassmorphism, efeitos Glow (Neon) e micro-interações fluidas a 60FPS usando o motor Impeller do iOS.

---

## ✨ Funcionalidades Principais

* **🧠 Rastreamento com Inteligência Artificial:** Integração direta com a API do Google Gemini (gemini-2.5-flash). Basta digitar "Comi 150g de arroz e 300g de frango" e o app calcula calorias e macronutrientes instantaneamente.
* **⚙️ Macros Dinâmicos:** Cálculo automático das necessidades calóricas e de macronutrientes baseado no peso atual do usuário atualizado em tempo real.
* **🏆 Gamificação e Conquistas:** Sistema de recompensas e medalhas que reagem aos dados do usuário (ex: alertas e troféus desbloqueados ao bater a meta de água diária).
* **📊 Dashboard Evolutivo:** Acompanhamento do progresso de peso com gráficos gerados a partir do histórico de evolução real do atleta.
* **💾 Persistência Local:** Gerenciamento de estado otimizado com `provider` e dados salvos no armazenamento interno via `shared_preferences`, garantindo inicialização instantânea (Zero Loading).

---

## 🛠️ Arquitetura e Tecnologias

O projeto foi construído seguindo boas práticas de engenharia de software mobile, separação de responsabilidades e foco em performance:

* **Gerenciamento de Estado:** `provider` (Single Source of Truth na camada de visualização).
* **Persistência de Dados:** `shared_preferences` para armazenamento NoSQL leve e rápido.
* **Integração de IA:** `google_generative_ai` para processamento de linguagem natural.
* **Segurança:** `flutter_dotenv` para proteção e ofuscação da API Key.
* **Motion Design:** `flutter_animate` para animações em cascata (Staggered Animations) e Tween Builders.
* **Splash & Icons:** `flutter_native_splash` e `flutter_launcher_icons` para integração nativa com iOS/Android.

---

## 🚀 Como Executar o Projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/matheussilva/bulkingtracker.git](https://github.com/matheussilva/bulkingtracker.git)
