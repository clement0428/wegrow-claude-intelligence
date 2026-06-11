---
name: Project Mode — Persistent Project Tracking
description: Rules for auto-loading and saving project context from C:\Users\cowle\OneDrive\文件\Claude\Projects
type: feedback
---

All work involving a named project must follow the Project Mode workflow.

**Why:** User wants conversation progress and direction to be persistently tracked per project, not lost between sessions. Projects live in OneDrive for cross-device access.

**How to apply:**

## Directory structure
```
C:\Users\cowle\OneDrive\文件\Claude\Projects\
├── PROJECTS.md          ← 總索引 (status, last updated)
└── <ProjectName>\
    └── project.md       ← per-project detail
```

## On conversation START
- If the user mentions a project name (or a topic clearly matching a project folder), read `project.md` immediately to restore context
- Briefly summarize "上次進度" to the user before proceeding

## On conversation END / milestone
- Append a new row to `project.md` → 對話記錄摘要 table (date + 1-line summary)
- Update `project.md` → 下次繼續 checklist (tick completed items, add new ones)
- Update `project.md` → 狀態 and 最後更新 fields
- Update `PROJECTS.md` index row (status + date)

## project.md template (for new projects)
```markdown
# Project：<名稱>

## 基本資訊
| 欄位 | 內容 |
|------|------|
| **分類** | |
| **狀態** | 🟢 進行中 |
| **最後更新** | YYYY-MM-DD |
| **主要工具** | |

## 目標
<一段話描述>

## 現有成果
<bullet list>

## 進度摘要
<narrative>

## 下次繼續
- [ ] ...

## 對話記錄摘要
| 日期 | 摘要 |
|------|------|
| YYYY-MM-DD | ... |
```

## Status emoji legend
- 🟢 進行中 (Active)
- 🟡 暫停 (Paused)
- ✅ 完成 (Completed)
