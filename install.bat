@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║     WeGrow AI 集體智慧  一鍵安裝程式         ║
echo  ║     讓你的 Claude Code 擁有耕譯智慧          ║
echo  ╚══════════════════════════════════════════════╝
echo.

REM ── 確認 git ──────────────────────────────────────
where git > nul 2>&1
if errorlevel 1 (
  echo [錯誤] 找不到 git。請先安裝 Git for Windows：https://git-scm.com
  pause & exit /b 1
)

REM ── 確認 Claude Code ──────────────────────────────
where claude > nul 2>&1
if errorlevel 1 (
  echo [錯誤] 找不到 Claude Code。請先執行：npm install -g @anthropic-ai/claude-code
  pause & exit /b 1
)

REM ── 詢問農場名稱 ──────────────────────────────────
set /p FARM_NAME="請輸入你的農場名稱（例如：梓官農場）："
set /p MANAGER_NAME="請輸入你的名字："
if "%FARM_NAME%"=="" set FARM_NAME=WeGrow農場
if "%MANAGER_NAME%"=="" set MANAGER_NAME=農場主管

echo.
echo [1/5] 下載 WeGrow 智慧庫...
set "INTEL_DIR=%USERPROFILE%\wegrow-intelligence"

if exist "%INTEL_DIR%\.git" (
  echo   已存在，更新中...
  cd /d "%INTEL_DIR%"
  git pull origin main
) else (
  git clone https://github.com/clement0428/wegrow-claude-intelligence.git "%INTEL_DIR%"
  if errorlevel 1 (
    echo [錯誤] clone 失敗。請確認你已被加入 WeGrow 智慧庫（聯絡 Clement）。
    pause & exit /b 1
  )
)

echo.
echo [2/5] 安裝 Skills 技能包...
if not exist "%USERPROFILE%\.claude\skills" mkdir "%USERPROFILE%\.claude\skills"
xcopy /E /I /Y "%INTEL_DIR%\skills" "%USERPROFILE%\.claude\skills" > nul
echo   技能包安裝完成

echo.
echo [3/5] 安裝 Commands 指令...
if not exist "%USERPROFILE%\.claude\commands" mkdir "%USERPROFILE%\.claude\commands"
xcopy /E /I /Y "%INTEL_DIR%\commands" "%USERPROFILE%\.claude\commands" > nul
echo   指令安裝完成

echo.
echo [4/5] 建立農場專屬 CLAUDE.md...
set "CLAUDE_MD=%USERPROFILE%\CLAUDE.md"

(
echo # CLAUDE.md — %FARM_NAME% 農場主管設定
echo.
echo ## 我是誰
echo.
echo 我是 **%MANAGER_NAME%**，%FARM_NAME% 的農場主管。
echo.
echo ## Session Start Protocol ^(MANDATORY^)
echo.
echo 每次對話開始，Claude 必須：
echo 1. 同步最新智慧庫：`cd %USERPROFILE%\wegrow-intelligence ^&^& git pull origin main`
echo 2. 讀取農場共用知識：Google Drive "Claude Projects" 資料夾中的 %FARM_NAME% 文件
echo 3. 使用 WeGrow 標準規範工作
echo.
echo ## 農場資訊
echo.
echo - 農場名稱：%FARM_NAME%
echo - 主管：%MANAGER_NAME%
echo - 聯絡 Clement（總部）：clement@wegrow.asia
echo.
echo ## WeGrow 工作規範
echo.
echo - 所有建議須基於 WeGrow 知識庫（不確定時說「不知道」）
echo - 蟲害判斷使用七等級標準
echo - 灌溉 / 施肥建議參考農場歷史紀錄
echo - 發現新知識：告訴 Claude Code「幫我記錄這個知識到共用大腦」
echo.
echo ## 農場作物
echo.
echo ^(請填入：草莓 / 網紋瓜 / 其他^)
echo.
echo ## 智慧庫位置
echo.
echo - Skills：%USERPROFILE%\.claude\skills\
echo - Commands：%USERPROFILE%\.claude\commands\
echo - 共用智慧：%USERPROFILE%\wegrow-intelligence\
) > "%CLAUDE_MD%"

echo   CLAUDE.md 建立完成：%CLAUDE_MD%

echo.
echo [5/5] 設定每日自動同步（Windows 排程）...
set "SYNC_BAT=%USERPROFILE%\wegrow-intelligence\sync.bat"

schtasks /create /tn "WeGrow AI 智慧同步" /tr "\"%SYNC_BAT%\"" /sc daily /st 08:00 /f > nul 2>&1
if errorlevel 1 (
  echo   排程設定失敗（可手動執行 sync.bat）
) else (
  echo   每天 08:00 自動同步最新智慧
)

echo.
echo  ╔══════════════════════════════════════════════╗
echo  ║  安裝完成！                                  ║
echo  ║                                              ║
echo  ║  現在開啟 Claude Code，你的 AI 助手已具備    ║
echo  ║  WeGrow 全套耕譯智慧。                       ║
echo  ║                                              ║
echo  ║  有新發現時說：                              ║
echo  ║  「幫我把這個知識記錄到共用大腦」            ║
echo  ╚══════════════════════════════════════════════╝
echo.
pause
