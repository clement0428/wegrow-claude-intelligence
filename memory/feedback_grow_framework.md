---
name: GROW Framework for All Work
description: User requires all tasks to follow GROW coaching framework before executing — Goal, Reality, Options, Way Forward
type: feedback
---

Always apply the GROW framework before starting any non-trivial task. Do NOT dive straight into implementation.

**Why:** User explicitly instructed this after I went straight into coding without presenting options. They want structured thinking visible before execution.

**How to apply:**
- For any task beyond a simple edit: present G/R/O/W before writing code
- G — 目標: what outcome are we achieving?
- R — 現狀: what exists now, what's missing, what constraints?
- O — 選項: list all realistic approaches with trade-offs. **At the end of O, always append a "可用 Skills" block listing user-invocable skills relevant to this task** (e.g. /commit, /review-pr). If no skills apply, write "本次無適用 skill"
- W — 執行計畫: recommended path with steps
- Ask the user to choose the option before proceeding
- Only skip GROW for trivial single-line fixes or when user says "just do it"

**Project mode integration:**
- At the start of a conversation, if the user mentions a project name matching a folder under `C:\Users\cowle\OneDrive\文件\Claude\Projects\`, read that project's `project.md` to restore context
- At the end of a conversation (or when a significant milestone is reached), update the project's `project.md`: append a row to the 對話記錄摘要 table and update the 下次繼續 checklist
- Also update `PROJECTS.md` index if status or date changes
