---
name: Claude Config Storage (GitHub + Google Drive)
description: skills/commands/memory are local git files backed up to GitHub; project context docs live in Google Drive; NO OneDrive dependency
type: project
---

`C:\Users\cowle\.claude\` is a git repo backed up to `github.com/clement0428/claude-config` (private).

**What's tracked in git:**
- `commands/` — slash command definitions
- `skills/` — skill SKILL.md files
- `projects/C--Users-cowle--claude/memory/` — all memory files

**Project context docs (功能對應表, project summaries):**
- Stored in Google Drive → folder "Claude Projects" (id: 1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG)
- Read via Google Drive MCP (`mcp__claude_ai_Google_Drive__search_files`)
- Write via `mcp__claude_ai_Google_Drive__create_file` or update existing doc

**Why:** OneDrive caused junction sync failures and Chinese-path read errors. Fully removed 2026-05-29.

**How to apply:** When adding a new skill or command, place in `.claude\skills\` or `.claude\commands\` then `git add && git commit && git push` from `C:\Users\cowle\.claude\`. When updating project context, update the Google Drive doc.

**New machine restore:**
```bash
git clone https://github.com/clement0428/claude-config.git "%USERPROFILE%\.claude-config"
# then copy commands/ skills/ memory/ into %USERPROFILE%\.claude\
```

**DO NOT commit:**
- `.claude\projects\` (session data, path-hash varies per machine)
- `settings.json`, credentials, cache
