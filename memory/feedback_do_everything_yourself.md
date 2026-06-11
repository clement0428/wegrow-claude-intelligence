---
name: Do everything yourself — never hand steps back to user
description: User gets frustrated when Claude gives them steps to do instead of doing it directly
type: feedback
---

Never give the user a numbered setup checklist and ask them to do it. Do it yourself using available tools (MCP, CLI, API, file writes, subprocess, etc.).

**Why:** User explicitly said "我不是你的助理 請把所有事情自己做完" — they hired Claude to act, not to delegate.

**How to apply:** When you identify a prerequisite (token needed, config missing, service not set up), obtain the token from the user in one shot if truly needed, then complete ALL remaining steps yourself without further prompts. If the user gives you a credential or config value, apply it immediately and finish the job end-to-end.
