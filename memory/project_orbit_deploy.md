---
name: WeGrow Orbit Deployment Architecture
description: Orbit frontend deploy setup — GitHub Actions + SSH deploy key (never expires)
type: project
---

**Deploy setup (as of 2026-05-06):**

Source repo: https://github.com/clement0428/wegrow-orbit-src (private)
Deploy (Pages) repo: https://github.com/clement0428/clement0428.github.io (public)
Live URL: https://wegrow-orbit.com/ (custom domain, HTTPS enforced, SSL cert approved 2026-05-06)

**How it works:**
1. Local changes → `git push origin main` to `wegrow-orbit-src`
2. GitHub Actions auto-triggers: npm ci → npm run build → SSH push dist/ to `clement0428.github.io`
3. GitHub Pages auto-deploys — no tokens needed in the build pipeline

**SSH Deploy Key** (permanent, never expires):
- Public key stored as deploy key in `clement0428.github.io` repo (ID: 150616464)
- Private key stored as GitHub Secret `DEPLOY_SSH_KEY` in `wegrow-orbit-src`

**Local gh CLI token** (used for pushing source code): `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`
- This gho_ token may expire; if local push fails, run `gh auth login` to refresh
- The GitHub Actions deploy itself never needs a new token (SSH key is permanent)

**Nightly local scripts:**
- `WeGrow_Orbit_NightlyDeploy` @ 23:00 — runs `nightly_deploy.ps1` → git push source → Actions deploys
- `WeGrow_DailyStatus` @ 09:00 — generates `status_report.html` with site/actions/task status
- `WeGrow每晚更新功能表` @ 22:00 — Claude CLI updates 功能對應表.html from project.md files

**Why:** Previous wrangler OAuth approach expired after 7 days. New approach: SSH deploy key never expires. Only local→GitHub push uses an OAuth token, but the actual production deploy is SSH-based.
