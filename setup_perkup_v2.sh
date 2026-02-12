#!/usr/bin/env bash
set -euo pipefail

mkdir -p backend/src frontend/css frontend/js .github/workflows

cat > backend/package.json <<'JSON'
{
  "name": "perkup-v2-backend",
  "version": "1.0.0",
  "type": "module",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js"
  },
  "dependencies": {
    "@fastify/cors": "^9.0.1",
    "dotenv": "^16.4.5",
    "fastify": "^4.28.1"
  }
}
JSON

cat > backend/src/app.js <<'JS'
import Fastify from 'fastify';
import cors from '@fastify/cors';
import dotenv from 'dotenv';

dotenv.config();

const app = Fastify({ logger: true });
const port = Number(process.env.PORT || 3000);

await app.register(cors, { origin: true });

app.get('/health', async () => ({ status: 'ok' }));

const start = async () => {
  try {
    await app.listen({ port, host: '0.0.0.0' });
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};

start();
JS

cat > backend/.env <<'ENV'
PORT=3000
ENV

cat > backend/.gitignore <<'TXT'
node_modules
.env
TXT

cat > frontend/index.html <<'HTML'
<!doctype html>
<html lang="uk">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>PerkUp v2</title>
    <link rel="stylesheet" href="./css/style.css" />
  </head>
  <body>
    <main class="container">
      <h1>PerkUp v2</h1>
      <p>Натисніть кнопку, щоб перевірити API бекенду.</p>
      <button id="checkApiBtn" type="button">Перевірити API</button>
      <pre id="apiResult">Очікування запиту...</pre>
    </main>

    <script type="module" src="./js/api.js"></script>
  </body>
</html>
HTML

cat > frontend/css/style.css <<'CSS'
:root {
  color-scheme: dark;
  --bg: #0f172a;
  --surface: #1e293b;
  --text: #e2e8f0;
  --accent: #38bdf8;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  display: grid;
  place-items: center;
  font-family: Inter, system-ui, -apple-system, Segoe UI, Roboto, sans-serif;
  background: radial-gradient(circle at top, #1e293b, var(--bg));
  color: var(--text);
}

.container {
  width: min(90vw, 720px);
  padding: 2rem;
  background: color-mix(in srgb, var(--surface) 85%, black 15%);
  border: 1px solid #334155;
  border-radius: 16px;
  box-shadow: 0 10px 35px rgb(0 0 0 / 35%);
}

h1 {
  margin-top: 0;
}

button {
  margin-top: 0.5rem;
  padding: 0.6rem 1rem;
  border: 0;
  border-radius: 10px;
  background: var(--accent);
  color: #082f49;
  font-size: 1rem;
  font-weight: 700;
  cursor: pointer;
}

pre {
  margin-top: 1rem;
  padding: 1rem;
  border-radius: 10px;
  background: #020617;
  border: 1px solid #1e293b;
  white-space: pre-wrap;
}
CSS

cat > frontend/js/api.js <<'JS'
const button = document.querySelector('#checkApiBtn');
const result = document.querySelector('#apiResult');

const fetchHealth = async () => {
  result.textContent = 'Завантаження...';

  try {
    const response = await fetch('http://localhost:3000/health');

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }

    const data = await response.json();
    result.textContent = JSON.stringify(data, null, 2);
  } catch (error) {
    result.textContent = `Помилка: ${error.message}`;
  }
};

button?.addEventListener('click', fetchHealth);
JS

cat > .github/workflows/deploy.yml <<'YML'
name: Deploy Frontend via FTP

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
      uses: actions/checkout@v4

      - name: Deploy frontend via FTP
      uses: SamKirkland/FTP-Deploy-Action@v4.3.5
      with:
        server: ${{ secrets.FTP_SERVER }}
        username: ${{ secrets.FTP_USERNAME }}
        password: ${{ secrets.FTP_PASSWORD }}
        local-dir: ./frontend/
        server-dir: ./
YML

cat > .gitignore <<'TXT'
node_modules
.DS_Store
.env
TXT

(
  cd backend
  npm install
)

echo "PerkUp v2 scaffold has been created and backend dependencies installed."
