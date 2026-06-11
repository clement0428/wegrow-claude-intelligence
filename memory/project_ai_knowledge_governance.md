---
name: 五年AI知識治理流程
description: WeGrow Obsidian 知識管理架構：AI每日MD流程、系統分工、Canonical三大類、五年原則
type: project
---

WeGrow 五年內 AI 筆記要同時滿足三件事：AI 好讀、人好用、事後可追溯。

**源文件：** `C:\Users\cowle\OneDrive\文件\Obsidian Vault\00-AI筆記規則\五年AI知識治理流程.md`

## 系統分工

| 系統 | 角色 | 不應做的事 |
|---|---|---|
| Obsidian | Markdown 母庫、知識連結、AI 長期記憶 | 不直接把所有 AI 草稿當正式知識 |
| Git | 版本控管、歷史追溯、還原 | 不當日常操作介面 |
| Notion | 團隊 dashboard、任務、CRM、審核狀態 | 不當唯一真相來源 |
| GitHub docs | Orbit 技術、production gate、程式證據 | 不收業務雜訊與未審核草稿 |

## 每日 AI MD 流程

```
AI 每日產生 MD
  -> 00-AI每日收件匣/01-Inbox
  -> 分類、去重、補連結
  -> 02-Reviewed 或 03-Needs-Human-Review
  -> 正式吸收到三大類
  -> 原稿封存到 04-Archive
  -> 衝突登記到 05-Conflict-Log
```

**Inbox 路徑：** `Obsidian Vault/00-AI每日收件匣/01-Inbox/`

## Canonical 三大類（Obsidian 正式知識庫）

- `Wegrow-Orbit/` — Orbit 技術、production 紀錄
- `WeGrow-Terra/` — 農電開發 pipeline
- `Wegrow-sales/` — 銷售 CRM、客戶紀錄

## 五年原則

1. Markdown 是母格式；Notion、CRM、dashboard 都是呈現層
2. AI 每日建議先進 inbox，不直接覆蓋正式筆記
3. 每份正式筆記必須有來源、日期、分類、相關連結
4. 每次 AI 發現衝突，先記錄衝突，不擅自合併
5. 技術與 production 證據要回到 GitHub / repo docs
6. 客戶追蹤與團隊任務可同步到 Notion，但正式知識仍回到 Obsidian/Git

**Why:** 2026-06-07 Clement 建立，確保五年後知識仍可追溯，AI 草稿不污染正式知識庫。

**How to apply:** 每次 Claude 產生重要知識（SOP、農場方案、技術決策）時，提醒用戶是否要走 Inbox → Review → Canonical 流程入庫。衝突優先記錄不合併。
