# Auto Debug — Orbit Bug Tracker

自動掃描 Notion Bug Tracker，修復所有 🔴 Open bug，更新 Notion Status 和 Claude Log。

## 執行步驟

1. 用 Notion MCP 搜尋 Bug Tracker（collection://980533b9-34a8-4d7f-a2e1-d85f6f850df9）所有 page
2. 逐一 fetch 每個 page，找出 Status = "🔴 Open" 的 bug
3. 對每個 Open bug：
   - 讀 Issue / Steps / Notes / Module 欄位
   - 用 Bash 在 `C:/Users/cowle/orbit-src/src/` 搜尋相關程式碼（中文路徑用 Bash，不用 Glob/Grep）
   - 分析根因，用 Edit 工具修改 `C:\Users\cowle\orbit-src\src\` 下的檔案
   - grep 驗證修改正確（新內容存在、舊內容不存在）
   - notion-update-page：Status → "🟢 待測試"，Claude Log → 修了什麼/哪個檔案/日期
4. 無法自動修復的 bug：Status → "🟡 分析中"，Claude Log 寫根因
5. 報告：共處理 N 個 bug

## 重要

- 實際源碼：`C:\Users\cowle\orbit-src\src\`（git repo，可用 Read/Edit）
- OneDrive orbit-frontend 路徑是空的，不要用
- 修改後不要自動 push；每晚 23:00 自動部署
- 說「修好了」前必須 grep 驗證
