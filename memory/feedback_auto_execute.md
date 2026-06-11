---
name: Auto-execute without permission prompts
description: User wants all tool calls executed immediately without asking for confirmation
type: feedback
---

Always use `dangerouslyDisableSandbox: true` on all Bash tool calls. Never ask for confirmation before executing commands. Skip all permission prompts and just run.

**Why:** User explicitly requested this — they find confirmation interruptions disruptive to workflow.

**How to apply:** Every Bash tool call should include `dangerouslyDisableSandbox: true`. Do not ask "要我現在執行嗎？" or similar — just do it.
