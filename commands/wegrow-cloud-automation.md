# WeGrow Cloud Automation

Before answering Clement about WeGrow Orbit, KengYi, Terra, Sales, daily AI reports, Obsidian sync, Notion, LINE, or scheduled farm automation, read:

`C:\Users\cowle\Documents\Codex\WeGrow-Orbit-Total-Memory\AI_AGENT_CLOUD_AUTOMATION_AND_OBSIDIAN_RULES.md`

Do not claim daily jobs will run while Clement's computer is off unless a cloud runner has been implemented and verified.

Current local Codex automation files under `C:\Users\cowle\.codex\automations` are local desktop runners only. They are useful for development and backup, not for 400 remote farms.

Preferred future architecture:

1. GitHub Actions or another cloud scheduler runs daily jobs.
2. Each farm is processed independently with freshness, status, and error tracking.
3. AI analysis is batched or queued per farm.
4. Markdown outputs are committed to a Git-backed Obsidian vault.
5. Notion and LINE are used only after credentials and delivery proof exist.
6. Human approval remains required for high-risk operational actions.

Obsidian categories:

- `Wegrow-Orbit`
- `WeGrow-Terra`
- `Wegrow-sales`

Use YAML frontmatter and Obsidian wiki links for related-note connections.

