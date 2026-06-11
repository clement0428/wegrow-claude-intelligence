---
name: Check project context before answering architecture/infra questions
description: Never give generic "you don't have X" answers without reading project.md and memory first
type: feedback
---

Before answering ANY question about infrastructure, servers, databases, APIs, or deployment — ALWAYS read project.md and memory first.

User proved the error: said "I don't think you have a server, here are options" when `api.wegrow-orbit.com` was already live and running.

**Why:** I didn't run Session Start Protocol (read 功能對應表.html + all project.md). Gave generic advice that wasted time and caused justified anger.

**How to apply:**
- Session start = ALWAYS read `C:\Users\cowle\OneDrive\文件\Claude\Projects\1.功能對應表.html` + all `project.md` files BEFORE any work
- If user asks "why doesn't X work across devices / why isn't data syncing / where is my server" → check project.md + memory BEFORE answering
- Never say "you don't have X" without verifying
