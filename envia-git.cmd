```bat
@echo off
setlocal
cd /d "C:\Dev\cria-sites\site" || exit /b 1

set "REPO_URL=%~1"

if "%REPO_URL%"=="" (
    echo Uso: envia-git.cmd URL_DO_REPOSITORIO
    pause
    exit /b 1
)

echo Configurando repositorio remoto...
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto erro

git branch -M main
if errorlevel 1 goto erro

echo Adicionando arquivos...
git add .
if errorlevel 1 goto erro

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Atualizacao do projeto"
    if errorlevel 1 goto erro
)

echo Integrando alteracoes do GitHub...
git pull origin main --allow-unrelated-histories --no-rebase
if errorlevel 1 goto erro

echo Enviando para o GitHub...
git push -u origin main
if errorlevel 1 goto erro

echo.
echo Publicacao concluida!
pause
exit /b 0

:erro
echo.
echo Ocorreu um erro. Leia a mensagem acima antes de continuar.
pause
exit /b 1
```