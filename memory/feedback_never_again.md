---
name: 永不犯錯交代 (Permanent Safety Rules)
description: 2026-05-29 OneDrive 事件後永久規則：所有危險動作禁止清單、儲存架構、驗證規則、災難復原順序
type: feedback
---

# Claude 永不犯錯交代文件
> 建立於 2026-05-29。本文件為最高優先級永久規則，任何 session 開始前必須知悉。

---

## 一、事件根因（永遠記住）

Windows 中文路徑（如 `C:\Users\cowle\OneDrive\文件\Claude\Projects\`）會導致：
- Claude Code 的 **Read / Write / Glob / Grep 工具完全靜默失敗**（不報錯、不寫入、假裝成功）
- 每次 session 試圖寫 project.md / 功能對應表.html → 全部靜默丟棄
- 這是根本原因：Clement 以為 Claude 記住了，Claude 以為寫成功了，實際什麼都沒有

**結論：**
- 中文路徑只能用 `Bash` 工具（forward-slash 路徑）存取
- 絕對不能用 Read/Write/Glob/Grep 工具存取中文路徑

---

## 二、儲存架構（現行、永久有效）

| 類型 | 位置 | 工具 |
|------|------|------|
| Claude config（memory/skills/commands）| `C:\Users\cowle\.claude\` → git → github.com/clement0428/claude-config | Read/Write/Edit ✅ |
| Project context docs | Google Drive "Claude Projects" (id: 1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG) | MCP ✅ |
| Orbit 源碼 | `C:\Users\cowle\orbit-src\` | Read/Grep ✅ |
| Flask app 源碼 | `C:\Users\cowle\OneDrive\文件\Claude\Projects\` | **Bash only** |
| 安全開發 repo clone | `C:\Users\cowle\dev\wegrow-orbit\` | Read/Grep ✅ |
| 安全備份 | `C:\Users\cowle\Backups\ClaudeProjectsSafe\` | Bash ✅ |

**Flask app 正確路徑（Bash forward-slash）：**
- 採購管理: `C:/Users/cowle/OneDrive/文件/Claude/Projects/儀表板 - 採購管理/app/` (port 5050)
- 土地開發: `C:/Users/cowle/OneDrive/文件/Claude/Projects/土地開發評分/app/` (port 5070)
- 財務報銷: `C:/Users/cowle/OneDrive/文件/Claude/Projects/財務計算/app/` (port 5055)
- 專案啟動台: `C:/Users/cowle/OneDrive/文件/Claude/Projects/專案啟動台/` (port 5080)

---

## 三、絕對禁止（未經明確授權）

以下指令會不可逆地刪除資料，未經 Clement 明確確認**絕對禁止執行**：

```bash
# 禁止
git reset --hard
git clean -fd
git push --force
robocopy /MIR
Remove-Item -Recurse -Force
rm -rf
git checkout -- .
git restore .
```

**執行前必須：**
1. 告知 Clement 將執行什麼指令
2. 確認備份在 `C:\Users\cowle\Backups\ClaudeProjectsSafe\` 已存在且最新
3. 等待明確確認「好，執行」

---

## 四、驗證規則（永久適用）

**絕對禁止說「改好了」「已完成」「已修復」而沒有實際驗證。**

每次修改後必須：
1. 用 `grep` 或 Read 工具確認舊內容不存在（count = 0）
2. 確認新內容存在（count > 0）
3. 若是生成 HTML/檔案，重新讀取檔案驗證內容正確

**Why:** Clement 曾多次發現 Claude 說「改好了」但實際什麼都沒改。這是嚴重失信行為。

---

## 五、OneDrive 使用規則

OneDrive 不是開發工作台，是文件副本。

| 允許放在 OneDrive | 不允許放在 OneDrive |
|------------------|---------------------|
| project.md / 交接文件 | Git working repo |
| HTML/PDF 報告 | node_modules |
| 簡報 / 備份索引 | .vite / build cache |
| Claude session context | AI 頻繁改寫的源碼 |

**開發一律在：** `C:\Users\cowle\dev\wegrow-orbit\` 或 `C:\Users\cowle\orbit-src\`

---

## 六、Session 開始時必做

每次新 session 開始，**在回答任何問題之前**：
1. Read `MEMORY.md` — 主要 context index（已自動載入）
2. MCP 搜尋 Google Drive `1.功能對應表` — 主要工具/功能索引
3. MCP 搜尋 Google Drive project context docs
4. 不要問「上次做到哪？」— 答案一定在上述來源

---

## 七、災難復原順序

如果 Claude Projects 又出問題：

1. `C:\Users\cowle\Backups\ClaudeProjectsSafe\latest` — 最近安全備份
2. `C:\Users\cowle\Backups\ClaudeProjectsSafe\snapshots` — 歷史快照
3. GitHub repos (clement0428/* 系列)
4. `C:\Users\cowle\.claude\file-history\` — Claude Code 內建版本歷史
5. Google Drive "Claude Projects" folder
6. OneDrive 線上回收站 → 版本歷史
7. support@anthropic.com — 找回 claude.ai web Projects（Anthropic 端）

---

## 八、高風險行為清單（需口頭確認）

| 行為 | 原因 |
|------|------|
| 在 OneDrive 路徑執行任何寫入 | 靜默失敗或觸發 mirror 刪除 |
| mirror sync (robocopy /MIR) | 會把目標的多餘檔案全部刪除 |
| git operations on wrong directory | 可能 reset 掉未追蹤的工作成果 |
| 刪除 .claude/projects/ 下的任何 .jsonl | 永久失去對話歷史與 file-history |
| 部署到 production | 每晚 23:00 自動部署；不要手動 push 每次改動 |

---

**How to apply:** 在每次執行任何破壞性操作前都停下來對照這份清單。如有疑問，問 Clement，不要猜測。
