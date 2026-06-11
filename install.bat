@echo off
chcp 65001 > /dev/null
setlocal EnableDelayedExpansion

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║     WeGrow AI 集體智慧  一鍵安裝程式         ║
echo  ║     讓你的 Claude Code 擁有耕譯智慧          ║
echo  ╚══════════════════════════════════════════════╝
echo.

REM ── 確認 git ──
where git > /dev/null 2>&1
if errorlevel 1 ( echo [錯誤] 請先安裝 Git for Windows：https://git-scm.com & pause & exit /b 1 )

REM ── 確認 Claude Code ──
where claude > /dev/null 2>&1
if errorlevel 1 ( echo [錯誤] 請先執行：npm install -g @anthropic-ai/claude-code & pause & exit /b 1 )

REM ── 詢問農場資訊 ──
set /p FARM_NAME="請輸入農場名稱（例如：梓官農場）："
set /p MANAGER_NAME="請輸入你的名字："
if "%FARM_NAME%"=="" set FARM_NAME=WeGrow農場
if "%MANAGER_NAME%"=="" set MANAGER_NAME=農場主管

set "INTEL_DIR=%USERPROFILE%\wegrow-intelligence"

echo.
echo [1/6] 下載 WeGrow 智慧庫...
if exist "%INTEL_DIR%\.git" (
  cd /d "%INTEL_DIR%" && git pull origin main
) else (
  git clone https://github.com/clement0428/wegrow-claude-intelligence.git "%INTEL_DIR%"
  if errorlevel 1 ( echo [錯誤] 請確認 Clement 已將你加入智慧庫。 & pause & exit /b 1 )
)

echo.
echo [2/6] 安裝 Skills 技能包...
if not exist "%USERPROFILE%\.claude\skills" mkdir "%USERPROFILE%\.claude\skills"
xcopy /E /I /Y "%INTEL_DIR%\skills" "%USERPROFILE%\.claude\skills" > /dev/null

echo [3/6] 安裝 Commands 指令...
if not exist "%USERPROFILE%\.claude\commands" mkdir "%USERPROFILE%\.claude\commands"
xcopy /E /I /Y "%INTEL_DIR%\commands" "%USERPROFILE%\.claude\commands" > /dev/null

echo.
echo [4/6] 設定 Claude Code 權限（settings.json）...
if not exist "%USERPROFILE%\.claude" mkdir "%USERPROFILE%\.claude"
if not exist "%USERPROFILE%\.claude\settings.json" (
  copy "%INTEL_DIR%\settings.json.template" "%USERPROFILE%\.claude\settings.json" > /dev/null
  echo   settings.json 已建立
) else (
  echo   settings.json 已存在，略過（保留現有設定）
)

echo.
echo [5/6] 建立農場專屬 CLAUDE.md...
set "CLAUDE_MD=%USERPROFILE%\CLAUDE.md"
copy "%INTEL_DIR%\CLAUDE.md.template" "%CLAUDE_MD%" > /dev/null

REM 替換佔位符
powershell -Command "(Get-Content '%CLAUDE_MD%') -replace '\{\{FARM_NAME\}\}','%FARM_NAME%' -replace '\{\{MANAGER_NAME\}\}','%MANAGER_NAME%' | Set-Content '%CLAUDE_MD%' -Encoding UTF8"
echo   CLAUDE.md 已建立：%CLAUDE_MD%

echo.
echo [6/6] 設定每天 08:00 自動同步...
schtasks /create /tn "WeGrow AI 智慧同步" /tr "\"%INTEL_DIR%\sync.bat\"" /sc daily /st 08:00 /f > /dev/null 2>&1
if errorlevel 1 ( echo   排程設定失敗（可手動執行 sync.bat） ) else ( echo   每天 08:00 自動更新最新智慧 )

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║  ✅ 安裝完成！                               ║
echo  ║                                              ║
echo  ║  開啟 Claude Code，你的 AI 已具備            ║
echo  ║  WeGrow 耕譯全套智慧。                       ║
echo  ║                                              ║
echo  ║  發現新知識時說：                            ║
echo  ║  「幫我把這個知識記錄到 WeGrow 共用大腦」    ║
echo  ╚══════════════════════════════════════════════╝
echo.
pause
