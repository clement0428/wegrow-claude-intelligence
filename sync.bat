@echo off
chcp 65001 > nul
setlocal

set "INTEL_DIR=%USERPROFILE%\wegrow-intelligence"
set "REPO_URL=https://github.com/clement0428/wegrow-claude-intelligence.git"
set "LOG=%INTEL_DIR%\sync.log"

echo [WeGrow AI 同步] %date% %time% >> "%LOG%"
echo. >> "%LOG%"

REM ── 判斷是否已是 git repo
if exist "%INTEL_DIR%\.git" (
  echo [git pull] 更新中...
  cd /d "%INTEL_DIR%"
  git pull origin main >> "%LOG%" 2>&1
) else (
  echo [首次同步] 建立 git 連結中...
  cd /d "%INTEL_DIR%"
  git init >> "%LOG%" 2>&1
  git remote add origin "%REPO_URL%" >> "%LOG%" 2>&1
  git fetch origin main >> "%LOG%" 2>&1
  git reset --hard origin/main >> "%LOG%" 2>&1
)

if errorlevel 1 (
  echo [同步失敗] 請檢查網路或聯絡 Clement: clement@wegrow.asia
  type "%LOG%"
  exit /b 1
)

REM ── 把最新 skills/commands 複製到 Claude Code
xcopy /E /I /Y "%INTEL_DIR%\skills" "%USERPROFILE%\.claude\skills" > nul
xcopy /E /I /Y "%INTEL_DIR%\commands" "%USERPROFILE%\.claude\commands" > nul

echo [同步完成] WeGrow 智慧已更新到最新版本
