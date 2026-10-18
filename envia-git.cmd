@echo off
setlocal
cd /d "C:\Dev\cria-sites\site" || exit /b 1

set "REPO_URL=%~1"

if "%REPO_URL%"=="" (
    echo Uso: envia-git.cmd URL_DO_REPOSITORIO
    exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 git init

git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%"
) else (
    git remote set-url origin "%REPO_URL%"
)
if errorlevel 1 goto erro

git branch -M main || goto erro
git add . || goto erro

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Atualizacao automatica"
    if errorlevel 1 goto erro
)

git -c core.editor=true pull --no-rebase --no-edit --allow-unrelated-histories origin main
if errorlevel 1 goto erro

git push -u origin main
if errorlevel 1 goto erro

echo.
echo Publicacao concluida!
exit /b 0

:erro
echo.
echo Erro durante a publicacao. Verifique a mensagem acima.
pause
exit /b 1