@echo off
chcp 65001 > nul
setlocal

set "INTEL_DIR=%USERPROFILE%\wegrow-intelligence"

echo [WeGrow AI 同步] %date% %time%

cd /d "%INTEL_DIR%"
git pull origin main > "%INTEL_DIR%\sync.log" 2>&1
if errorlevel 1 (
  echo [同步失敗] 請檢查網路或聯絡 Clement
  type "%INTEL_DIR%\sync.log"
  exit /b 1
)

REM 把最新 skills/commands 複製到 Claude Code
xcopy /E /I /Y "%INTEL_DIR%\skills" "%USERPROFILE%\.claude\skills" > nul
xcopy /E /I /Y "%INTEL_DIR%\commands" "%USERPROFILE%\.claude\commands" > nul

echo [同步完成] WeGrow 智慧已更新到最新版本
type "%INTEL_DIR%\sync.log"
