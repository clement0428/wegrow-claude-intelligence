---
name: Orbit Backend Production Fix (2026-05-28)
description: Contabo VPS backend deploy mechanism + bugs fixed; frontend UI acceptance pending
type: project
---

**Production server is Contabo VPS at 185.227.134.38, NOT Railway.**

**How to deploy backend:**
- Repo: `clement0428/wegrow-orbit-src` (frontend repo, also contains `backend/` dir)
- Workflow: `.github/workflows/deploy-backend.yml` (has `workflow_dispatch`)
- Auth: SSH password via GitHub secret `SERVER_PASSWORD` (not key-based)
- Trigger: push to `main` with changes in `backend/**`, or manual dispatch (workflow ID 281509962)
- Workflow ID for dispatch: `281509962`
- GitHub token: `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`
- The workflow SCPs files → `docker cp` into `orbit-api` container → restart → migrations

**Container info:**
- Container name: `orbit-api`
- App path in container: `/app/app/`
- Host path: `/opt/orbit/orbit-backend/`
- Docker compose at: `/opt/orbit/infra/docker-compose.yml`

**Bugs fixed (2026-05-28):**
1. `ALTER TABLE farms ADD COLUMN greenhouses JSON` — P0 root cause of /farms/ 500
2. `ALTER TABLE product_master ADD COLUMN stock_qty INTEGER DEFAULT 0`
3. `main.py` deployed → `/health/db` and `/health/redis` now live
4. `/health/db` checks: `users, farms, plan_archives, formula_groups` (removed `farm_groups` which doesn't exist)
5. `UserRole.owner` → `UserRole.admin` in `farms.py` (owner不存在enum，super_admin用戶會500)

**Current production status:**
- `/health` → `{"status":"ok"}` ✅
- `/health/db` → `{"status":"ok", all tables ok}` ✅
- `/health/redis` → `{"redis_connected":true,"sse_broadcast":"enabled"}` ✅
- `/farms/` → 401 (not 500) ✅
- `GET /orbit/formula-groups/e9348cd2-6cca-4583-a86d-8011032b5570` → 200, 2 groups: 產區 + 育苗防治 ✅

**Pending: frontend UI acceptance**
Farm: `e9348cd2-6cca-4583-a86d-8011032b5570` (台南麻豆草莓園)
Formula groups data intact: 產區 + 育苗防治

**Why:** Backend was running old code without `greenhouses` DB column, causing SELECT * on farms table to fail. Migration added column. Also fixed latent `UserRole.owner` crash for super_admin users.

**How to apply:** When asked about Orbit backend deployment, use SSH via GitHub Actions (not Railway, not direct SSH key). The deploy pipeline is the `Deploy Backend to Server` workflow in `wegrow-orbit-src`.
