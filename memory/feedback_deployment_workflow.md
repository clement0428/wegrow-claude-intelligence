---
name: Deployment Workflow
description: Stop deploying to Cloudflare after every change; work locally and deploy once per day at 11 PM
type: feedback
---

Do NOT run `npx wrangler pages deploy` after every code change. It wastes time and tokens.

**Why:** Cloudflare deployments are slow and consume context. Local dev server (http://localhost:5173 + backend port 8001) is sufficient for testing.

**How to apply:**
- After code changes: just run `npm run build` to verify no errors, then stop.
- The user will trigger Cloudflare deploy manually, or it runs via cron at 23:00 daily.
- Only deploy to Cloudflare when explicitly asked, or via the nightly cron.
