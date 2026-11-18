@echo off
setlocal
title Glasses Admin Dashboard - localhost
cd /d "%~dp0"

set "PORT=3000"
set "URL=http://localhost:%PORT%"

echo.
echo  ==========================================
echo    Glasses Admin Dashboard - servidor local
echo  ==========================================
echo.

where node >nul 2>nul
if errorlevel 1 goto sem_node

rem ---------- Com Node.js: instala, compila e serve ----------
if not exist "node_modules\esbuild" (
  echo  [1/3] Instalando dependencias ^(so na primeira vez^)...
  call npm install
  if errorlevel 1 goto erro
) else (
  echo  [1/3] Dependencias ja instaladas.
)

echo  [2/3] Gerando o build em dist\ ...
call npm run build
if errorlevel 1 goto erro

echo  [3/3] Abrindo %URL%
echo.
echo  Para parar o servidor, feche esta janela ou aperte Ctrl+C.
echo  Mudou o codigo? Feche e rode o start.bat de novo.
echo.
start "" cmd /c "timeout /t 3 >nul & start %URL%"
call npx --yes serve dist -l %PORT%
goto fim

rem ---------- Sem Node.js: serve o dist\ ja compilado ----------
:sem_node
echo  Node.js nao encontrado neste computador.
if not exist "dist\index.html" (
  echo  E a pasta dist\ tambem nao existe, entao nao ha o que abrir.
  echo  Instale o Node.js LTS em https://nodejs.org e rode o start.bat de novo.
  goto erro
)
echo  Abrindo a versao ja compilada da pasta dist\.
echo  Alteracoes em src\ NAO aparecem sem o Node.js ^(https://nodejs.org^).
echo.
echo  Para parar o servidor, feche esta janela ou aperte Ctrl+C.
echo.
start "" cmd /c "timeout /t 2 >nul & start %URL%"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0serve.ps1" -Root "%~dp0dist" -Port %PORT%
goto fim

:erro
echo.
echo  Algo deu errado. Leia a mensagem acima.
pause
exit /b 1

:fim
endlocal
