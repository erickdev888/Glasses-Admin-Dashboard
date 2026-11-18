# Glasses Admin Dashboard

Painel administrativo e financeiro de e-commerce (Vitrine Admin) com visual "liquid glass".
React 18 + Framer Motion, empacotado com esbuild em arquivos estáticos. 17 telas, 4 temas,
busca rápida (⌘K / Ctrl+K) e exportação CSV.

> Os dados são demonstrativos, gerados em `src/data.js`. Ainda não há backend, login nem API.

## Rodar no Windows

Dê dois cliques em `start.bat`. Ele abre o painel em http://localhost:3000.

- Com Node.js instalado: instala as dependências, gera o build e sobe o servidor.
- Sem Node.js: abre a versão já compilada da pasta `dist/` usando `serve.ps1` (PowerShell).

## Rodar pelo terminal (Windows, Mac ou Linux)

```bash
npm install
npm run build      # gera dist/
npx serve dist     # abre em http://localhost:3000
```

Não há recarregamento automático: depois de editar `src/` ou `public/`, rode `npm run build` de novo.

## Estrutura

| Pasta / arquivo | Para que serve |
| --- | --- |
| `src/` | Código-fonte (JSX). `main.jsx` é o ponto de entrada; `pages/` tem as telas |
| `public/` | `index.html` e `styles.css` |
| `dist/` | Build pronto para publicar em qualquer hospedagem estática |
| `build.cjs` | Script de build com esbuild |
| `start.bat` / `serve.ps1` | Ligam o site em localhost no Windows |

A documentação completa para desenvolvedores está na wiki do projeto.
