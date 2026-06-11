# WeGrow 集體 AI 智慧架構 — 完整說明文件

**Document version:** 2026-06-11-v3  
**Architecture owner:** Clement Lee（clement@wegrow.asia）  
**Last reviewed:** 2026-06-11  
**Change log:**
- v3（2026-06-11）：加入五年視角——GitHub Org 遷移、主管權限演進、Offboarding SOP、知識成熟度管線 L0–L4、AI 回答責任邊界、Audit log、AI Runtime 抽象層、中央 Knowledge API、備份與 DR、AI 測試集、年度架構檢討
- v2（2026-06-11）：修正 GitHub 權限矛盾、memory 分層、知識品質標準、禁止自動學習範圍、Drive 讀取說明、失敗恢復、權限模型、驗收 checklist
- v1（2026-06-11）：初版

**Breaking changes（v2 → v3）：無。v3 為純增補，不改變現有結構。**  
**Breaking changes（v1 → v2）：** memory/ 結構改變；settings.json 改最小權限；主管 GitHub 權限從 pull 改為 write。

---

## 定位聲明（請 AI 優先閱讀）

**本系統不是讓每台農場 AI 自由學習後自動改變全體行為，而是建立一個「受審核、可追溯、分權限、可回滾」的 WeGrow 農業知識協作網路。任何跨農場共享知識必須經過來源標記、適用範圍判斷與 Clement 審核，才能進入共用大腦。**

AI 的角色是**整理與格式化知識草稿**，不是自主決定哪些知識正確或適用全體農場。

**五年原則：本系統的核心不是 Claude Code、GitHub 或 Google Drive，而是「可審核、可追溯、可退役、可遷移」的農業知識治理制度。任何工具都可以替換，但知識來源、權限邊界、審核紀錄、適用範圍與責任歸屬不可消失。**

---

## 一、問題與目標

### 問題

WeGrow 管理多個草莓農場（目標規模：400 農場）。每個農場主管的電腦裝有 Claude Code，但每台電腦是孤立的：
- 沒有共用知識基礎
- 農場 A 學到的解法，農場 B 不知道
- Clement 訓練的 AI 行為規範無法複製到其他電腦

### 目標

| 目標 | 說明 |
|------|------|
| 共用大腦 | 所有農場主管的 Claude Code 從同一個知識庫出發 |
| 自動同步 | 每次開啟新對話自動取得最新智慧 |
| 受控知識回流 | 主管的發現可貢獻，但必須經審核才進入共用大腦 |
| 分層權限 | 不同類型知識有不同的可見範圍 |
| 可回滾 | 任何知識更新都有版本紀錄，可還原 |
| 可治理 | 5 年 400 農場後，權限、知識品質、責任歸屬仍可稽核 |

---

## 二、系統架構總覽

```
┌──────────────────────────────────────────────────────────────┐
│                   ☁️  雲端大腦（Layer 1）                      │
│                                                              │
│  GitHub Org: wegrow-org/wegrow-claude-intelligence（目標）    │
│  現階段：clement0428/wegrow-claude-intelligence（private）    │
│                                                              │
│  memory/shared/         ← 所有主管可讀                        │
│  memory/farm-public/    ← 跨農場學習（去識別化，L2+）         │
│  memory/farm-private/   ← 單一農場，不跨農場                  │
│  memory/clement-private/← 只有 Clement                       │
│  memory/review-pending/ ← 待審核（L0/L1）                    │
│                                                              │
│  Branch protection: main 只能 Clement PR merge               │
│  Google Drive: Claude Projects/農場主管/{農場}_project        │
└──────────────────────────────────────────────────────────────┘
        ↓ session start: git pull + read farm project
        ↑ contrib/* → PR → Clement review → merge main
┌──────────────────────────────────────────────────────────────┐
│               👨‍🌾  農場主管電腦（Layer 2）                      │
│                                                              │
│  AI Runtime（現：Claude Code，未來：可替換）                  │
│  ~/CLAUDE.md → Session Start Protocol                        │
│  ~/.claude/skills/ ~/.claude/commands/（從 GitHub 同步）      │
│  ~/wegrow-intelligence/（GitHub clone，write 權限）           │
└──────────────────────────────────────────────────────────────┘
        ↓ PR 送審       ↑ merge 後全員下次同步
┌──────────────────────────────────────────────────────────────┐
│               🔒  Clement 審核層（Layer 3）                    │
│                                                              │
│  收到 PR → 核對 metadata（L0→L2 升級決策）                    │
│  → approve merge → 全員同步                                   │
│  logs/contribution-log.csv + review-log.csv 記錄所有決策      │
└──────────────────────────────────────────────────────────────┘
```

---

## 三、GitHub Repository 結構

### Phase 1（現在）：個人帳號 private repo

**URL：** https://github.com/clement0428/wegrow-claude-intelligence

### Phase 2（10 農場以上）：遷移至 GitHub Organization

```
WeGrow GitHub Organization（wegrow-org）
├── wegrow-claude-intelligence   ← 智慧庫主 repo
├── team: farm-managers-read     ← 只能 pull（給未來降權主管）
├── team: farm-contributors      ← 可 push contrib/* 分支
├── team: reviewers              ← 可 approve PR（Clement + 未來審核員）
└── team: core-ai-admins         ← 可改 settings、branch protection
```

Organization 的優點（400 農場後必要）：
- 主管離職→ 移出 team，不用逐一刪 collaborator
- GitHub Audit Log：誰 push 了什麼、誰 merge 了什麼，完整稽核
- Branch protection 可設 required review、CODEOWNERS
- 未來可接 GitHub Actions 做自動化 review lint

### 分支策略

| 分支 | 誰可以寫 | 說明 |
|------|----------|------|
| `main` | 只有 Clement（透過 PR approve）| 穩定知識庫 |
| `contrib/{YYYYMMDD}-{主題}` | 農場主管（Phase 1）| 貢獻新知識 |

### Branch Protection（需手動在 GitHub 設定）

```
main:
✅ Require a pull request before merging
✅ Require approvals: 1（Clement）
✅ Dismiss stale approvals on new commits
✅ Require review from Code Owners
✅ Do not allow bypassing
```

### CODEOWNERS

```
# .github/CODEOWNERS
memory/   @clement0428
skills/   @clement0428
```

### 主管 GitHub 權限演進

| 階段 | 規模 | 主管權限 | 貢獻方式 |
|------|------|----------|----------|
| Phase 1（現在）| < 20 農場 | write（push contrib/*）| 直接 push branch + PR |
| Phase 2（中期）| 20–100 農場 | 移至 Org team: farm-contributors | 同上，但透過 Org 管理 |
| Phase 3（長期）| 100+ 農場 | read only | 主管提交 issue / 表單，bot 代開 PR |

Phase 3 改用 bot PR 的原因：400 台電腦 × 400 組 token，長期必有 credential 外洩、誤 push、離職帳號未清理的問題。

### 加入主管（現行指令）

```bash
gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{GitHub帳號} \
  --method PUT \
  --field permission=write
```

### 檔案結構

```
wegrow-claude-intelligence/
│
├── .github/
│   └── CODEOWNERS
│
├── ARCHITECTURE.md
├── CLAUDE.md.template
├── install.bat
├── sync.bat
├── settings.json.template
├── README.md
│
├── memory/
│   ├── MEMORY.md              # 索引（shared/ + farm-public/ L2+）
│   ├── shared/                # WeGrow 規範、AI 行為規則、品牌知識
│   ├── farm-public/           # 已審核跨農場知識（L2 以上）
│   │   └── {scope}_{主題}_{YYYYMMDD}.md
│   ├── farm-private/
│   │   └── {農場名稱}/        # 單一農場專屬
│   ├── clement-private/       # Clement 個人知識、專案脈絡
│   └── review-pending/        # 新貢獻草稿，待升級
│
├── skills/
│   ├── 人資搜尋/SKILL.md
│   └── 貢獻知識/SKILL.md
│
├── commands/
│   ├── 貢獻知識.md
│   └── ...
│
├── logs/
│   ├── contribution-log.csv   # 所有貢獻紀錄
│   ├── review-log.csv         # 所有審核決策
│   └── incident-log.md        # 知識錯誤事件
│
└── tests/
    ├── pest_questions.md
    ├── irrigation_questions.md
    ├── forbidden_pesticide_questions.md
    ├── farm-private-leakage-tests.md
    └── stale-knowledge-tests.md
```

---

## 四、Google Drive 結構與讀取說明

### 結構

```
Claude Projects/（id: 1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG）
│
├── 農場主管/
│   ├── _範本農場_project
│   └── {農場名稱}_project
│
├── WeGrow 新增農場主管 SOP（Clement 專用）
└── 1.功能對應表
```

### Claude Code 如何讀取 Google Drive

| 項目 | 說明 |
|------|------|
| 整合方式 | Claude.ai MCP Google Drive connector（cloud-hosted） |
| 主管需要 | 自己的 Claude.ai 帳號，且農場 project 文件已分享給他 |
| 讀取工具 | `mcp__claude_ai_Google_Drive__search_files`、`read_file_content` |
| 跨農場可見性 | 各農場文件只分享給對應主管，不開放跨農場讀取 |
| 讀取失敗回報 | Claude 必須明確說「無法讀取農場文件：{原因}，以本機快取繼續」，不可靜默跳過 |

**Fallback 順序：**
1. Google Drive MCP 讀取農場 project
2. 失敗 → `~/wegrow-intelligence/memory/farm-private/{農場名稱}/` 本機快取
3. 快取也無 → 繼續執行，但聲明「農場專屬文件不可用，建議可能不夠精準」

---

## 五、Session Start Protocol

```markdown
## Session Start Protocol（MANDATORY — 不可跳過）

### Step 1：同步
cd %USERPROFILE%\wegrow-intelligence && git pull origin main --quiet
失敗時：明確說「同步失敗（{原因}），以本機版本繼續」，不可靜默。
xcopy /E /I /Y skills "%USERPROFILE%\.claude\skills" > nul
xcopy /E /I /Y commands "%USERPROFILE%\.claude\commands" > nul

### Step 2：讀取共用記憶庫
讀 memory/MEMORY.md（只讀 shared/ 和 farm-public/ L2+，不讀 clement-private/）

### Step 3：讀取農場專屬文件
MCP 讀 Google Drive「Claude Projects/農場主管/{{FARM_NAME}}_project」
失敗照 fallback 順序。

### Step 4：確認就緒
說：「{{FARM_NAME}} 智慧已同步，我已準備好。今天有什麼需要幫忙？」
```

---

## 六、知識成熟度管線（L0–L4）

每條知識都有成熟度等級，AI 引用時必須標明等級。

| 等級 | 名稱 | 定義 | 存放位置 |
|------|------|------|----------|
| L0 | raw observation | 主管口述，單次，無量測 | review-pending/ |
| L1 | reviewed note | Clement 看過，確認邏輯合理，但未農場驗證 | review-pending/（標 L1）或 farm-private/ |
| L2 | single-farm validated | 單一農場多次驗證，有感測器或照片 | farm-public/ |
| L3 | multi-farm validated | 2 個以上農場獨立驗證 | farm-public/ |
| L4 | WeGrow standard SOP | 正式 SOP，納入培訓教材 | shared/ |

**AI 引用規則：**
- 引用 L0/L1 時必須說：「這是單一農場的初步觀察，尚未廣泛驗證」
- 引用 L2 時：「已在 {農場名稱} 驗證，其他農場情況可能不同」
- 引用 L3/L4 時：可直接建議，不需特別警語

---

## 七、知識品質標準與 Metadata

每個知識檔的 frontmatter：

```yaml
---
name: {知識標題}
description: {一行摘要}
type: farm-knowledge
maturity: L0 | L1 | L2 | L3 | L4
scope: strawberry | irrigation | pest | equipment | operation | other
farm: {貢獻農場}
applies_to: all_farms | similar_greenhouse | specific_farm_only
evidence: photo | sensor | operator_observation | experiment | external_reference
confidence: low | medium | high
risk_level: low | medium | high
reviewed_by:
review_date:
expires_or_recheck_after: {YYYY-MM-DD}
contributor: {主管姓名}
contributed_date: {YYYY-MM-DD}
---
```

### 知識過期與退役制度

農業知識有季節性，不能永久有效。執行機制：

| 頻率 | 動作 |
|------|------|
| 每月 | 列出 30 天內 expires_or_recheck_after 到期的知識，通知 Clement |
| 每季 | Clement review 所有 risk_level: high 的知識 |
| 每年 | 移除或降級未在期限內重新驗證的知識 |

到期未複查的知識：降級（如 L2 → L1）並移到 review-pending/，AI 不再引用為 validated。

---

## 八、禁止自動學習的範圍

| 禁止項目 | 處理方式 |
|----------|----------|
| 農藥劑量、施用比例、混用建議 | Claude 拒絕整理，說「農藥相關需 Clement 確認」 |
| 未驗證的做法 | 只進 review-pending/，maturity: L0，confidence: low |
| 主管口述的因果判斷 | evidence: operator_observation，不自動升 high confidence |
| AI 自身的建議 | 輸出是建議，不可回寫成已驗證知識 |
| 特定廠商 / 藥品名稱推薦 | 需 Clement 確認合規後才記錄 |

貢獻知識 skill 強制行為：
- 所有新知識進 review-pending/（不直接進 shared/ 或 farm-public/）
- maturity 預設 L0，confidence 預設 low
- 農藥相關 → 拒絕整理

---

## 九、AI 回答責任邊界

5 年後 AI 將更常被用於決策。必須明確邊界：

| AI 可以做 | AI 不可以做 |
|-----------|------------|
| 整理資訊、比較選項、提醒風險 | 單獨決定農藥、施肥的高風險變更 |
| 引用知識庫並標明 maturity 等級 | 把未執行的建議回寫成成功案例 |
| 說「建議考慮 X」 | 說「X 已驗證有效」（除非 maturity ≥ L2）|
| 在 L0/L1 知識上標警語 | 把 L0 直接呈現為 WeGrow 標準 |

高風險建議（risk_level: high）必須附：「此建議涉及高風險操作，請 Clement 或農業專家確認後執行。」

---

## 十、知識貢獻流程（`貢獻知識` Skill）

農場主管說：**「幫我把這個知識記錄到 WeGrow 共用大腦」**

```
1. 確認知識內容
   若涉及農藥劑量 → 拒絕，提示聯絡 Clement
   ↓
2. 填寫 metadata（maturity 預設 L0）
   ↓
3. 建立草稿：memory/review-pending/{scope}_{主題}_{YYYYMMDD}.md
   ↓
4. git checkout -b contrib/{YYYYMMDD}-{主題}
   git add + commit + push
   ↓
5. gh pr create --base main
   標題：[{農場}] {知識標題}
   body：maturity L0、evidence、confidence low、請 Clement 審核升級路徑
   ↓
6. 回報 PR URL，說明審核後才進入共用大腦
   同時寫入 logs/contribution-log.csv 一筆記錄
```

**Clement 審核 PR：**
1. 核對 metadata，決定升級到 L1/L2 或退回
2. 決定 applies_to（單一農場 → farm-private/；多農場 → farm-public/）
3. 填 reviewed_by + review_date + expires_or_recheck_after
4. merge main
5. 寫入 logs/review-log.csv

---

## 十一、Audit Log 與 Evidence Log

```
logs/
├── contribution-log.csv
│   欄位：date, contributor, farm, title, maturity, scope, pr_url
│
├── review-log.csv
│   欄位：date, reviewed_by, pr_url, title, decision(approved/rejected/revised),
│          final_maturity, applies_to, expires_or_recheck_after
│
├── incident-log.md
│   格式：## {日期} {標題}
│          原因：、影響農場：、處理：、防範：
│
└── ai-answer-evidence-log/
    （未來：每條高風險 AI 建議自動記錄引用了哪個知識 + maturity）
```

5 年後必須能回答：「這條知識誰加的？誰審的？哪個農場驗證的？AI 什麼時候引用過？有沒有造成過問題？」

---

## 十二、新增農場主管 SOP（Onboarding）

### 準備資料
主管姓名、農場名稱、GitHub 帳號、Claude.ai 帳號

### Step 1：加入 GitHub（write 權限）
```bash
gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{帳號} \
  --method PUT --field permission=write
```

### Step 2：建立 Google Drive 農場資料夾
複製 `_範本農場_project`，重命名，填入基本資料，分享給主管。

### Step 3：傳安裝說明
```
1. 安裝 Git for Windows（git-scm.com）
2. 安裝 Node.js LTS（nodejs.org）
3. cmd 執行：npm install -g @anthropic-ai/claude-code
4. 接受 GitHub 邀請 Email
5. 下載 install.bat，雙擊執行
6. 開啟 Claude Code，說「你好」確認成功
聯絡：clement@wegrow.asia
```

### Step 4：驗收 Checklist

```
□ ~/wegrow-intelligence/ 存在，git log 有最新 commit
□ ~/.claude/skills/貢獻知識/SKILL.md 存在
□ ~/.claude/commands/貢獻知識.md 存在
□ ~/CLAUDE.md 農場名稱已替換（非 {{FARM_NAME}}）
□ ~/CLAUDE.md 主管姓名已替換
□ Windows 排程「WeGrow AI 智慧同步」已建立
□ Claude Code 新對話回應包含農場名稱
□ Claude Code 可讀取 memory/MEMORY.md
□ Claude Code 可讀取 Google Drive 農場 project
□ /貢獻知識 可建立 PR 草稿（測試一筆）
□ sync.bat 執行後 sync.log 顯示 success
```

---

## 十三、主管離職 / 換人 SOP（Offboarding）

5 年 400 農場必然發生，必須有清單：

```
離職主管：{姓名}、農場：{農場名稱}、日期：{YYYY-MM-DD}

□ 移除 GitHub collaborator
  gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{帳號} \
    --method DELETE

□ 移除 Google Drive 農場資料夾分享權限
□ 確認沒有 open PR 未處理（close 或 assign 新主管）
□ 停用 Windows 排程（或主管電腦已還交）
□ 封存 memory/farm-private/{農場名稱}/ 到 memory/archived/{農場名稱}_{離職日期}/
□ 更新主管清單（標記「已離職」）
□ 寫入 logs/incident-log.md 一筆 offboarding 記錄
□ 若農場換新主管：重新執行 Onboarding SOP
```

---

## 十四、每日自動同步機制

| 機制 | 觸發時間 | 執行內容 | 失敗處理 |
|------|----------|----------|----------|
| Windows Task Scheduler | 每天 08:00 | sync.bat → git pull + xcopy | 寫 sync.log，不中斷 |
| Session Start Protocol | 每次新對話 | git pull + 讀 memory + 讀農場文件 | 明確告知，以舊版繼續 |

---

## 十五、失敗恢復流程

### git pull 衝突
```
git stash → git pull → git stash pop
仍衝突：保留遠端版本，通知 Clement
```

### repo 不存在
```
重新執行 install.bat
或手動：git clone https://github.com/clement0428/wegrow-claude-intelligence.git ~/wegrow-intelligence
```

### GitHub token 過期
```
症狀：403 / authentication failed
處理：gh auth login，重新輸入 token
```

### sync.bat 失敗 log
```
位置：~/wegrow-intelligence/sync.log
格式：{datetime} {success/fail} {message}
保留：30 天（sync.bat 自動清理）
```

### 主管離線
```
使用本機 memory/ 知識，無法讀 Google Drive
Claude 必須說：「離線模式，本機知識庫（上次同步：{時間}）」
```

### 回滾知識庫
```bash
cd ~/wegrow-intelligence
git log --oneline -10
git checkout {commit-hash}    # 切回舊版
# 通知 Clement 決定是否在 main revert
```

---

## 十六、安全與權限模型

### Claude Code settings.json（農場主管版）

```json
{
  "permissions": {
    "allow": [
      "Bash(git pull*)",
      "Bash(git checkout*)",
      "Bash(git add*)",
      "Bash(git commit*)",
      "Bash(git push*)",
      "Bash(gh pr create*)",
      "Bash(xcopy*)",
      "Read(%USERPROFILE%/wegrow-intelligence/*)",
      "Read(%USERPROFILE%/.claude/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/review-pending/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/farm-private/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/logs/*)"
    ],
    "deny": [
      "Bash(rm*)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/shared/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/clement-private/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/farm-public/*)"
    ],
    "defaultMode": "allowlist"
  },
  "autoUpdatesChannel": "latest",
  "skipDangerousModePermissionPrompt": false
}
```

> ⚠️ `bypassPermissions` 只允許在 Clement 的受控測試機，不作主管電腦預設。

### memory/ 存取矩陣

| 資料夾 | 本農場主管讀 | 本農場主管寫 | 他農場主管讀 | Clement |
|--------|------------|------------|------------|---------|
| shared/ | ✅ | ❌ | ✅ | ✅ |
| farm-public/（L2+）| ✅ | ❌（PR）| ✅ | ✅ |
| farm-private/{自己}/ | ✅ | ✅ | ❌ | ✅ |
| farm-private/{他人}/ | ❌ | ❌ | ❌ | ✅ |
| clement-private/ | ❌ | ❌ | ❌ | ✅ |
| review-pending/ | ✅（自己）| ✅（新增）| ❌ | ✅ |

---

## 十七、AI Runtime 抽象層

Claude Code 是**目前的實作工具**，不是不可替換的唯一選項。5 年內 Claude Code、MCP、Google Drive connector 版本都可能變。

**架構綁定的是協議，不是工具：**

```
AI Runtime Layer（抽象）
├── 必須能讀：memory/shared/、memory/farm-public/、farm project 文件
├── 必須能寫：memory/review-pending/（知識草稿）、logs/（貢獻紀錄）
├── 必須能執行：git pull（同步）、gh pr create（貢獻）
├── 禁止讀：clement-private/、其他農場 farm-private/
└── 禁止直接寫：shared/、farm-public/（只能透過 PR）

當前實作：Claude Code + GitHub CLI + Google Drive MCP
未來可替換為：任何符合上述協議的 AI agent
```

任何替換工具必須通過 `tests/` 下的測試集後才能上線。

---

## 十八、中央 Knowledge API（Phase 3 路線圖）

git pull + Google Drive 適合 Phase 1（< 20 農場），但 100+ 農場需要：

| 需求 | 現況 | Phase 3 目標 |
|------|------|-------------|
| 知識查詢 | git clone 全量同步 | REST API + vector search（語意搜尋）|
| 權限控管 | GitHub collaborator | API key per farm，server-side 控管 |
| 使用記錄 | 無 | 每次 AI 引用哪條知識都被 log |
| 過期警示 | 無 | API 自動標記 stale 知識 |
| 農場 context | Google Drive MCP | API 直接返回 farm profile |

GitHub 繼續當 source of truth（版控 + 審核），但不再是主管電腦的直接讀取層。

---

## 十九、備份與災難復原（DR）

| 指標 | 目標值 |
|------|------|
| RPO（最多損失多少資料）| 24 小時 |
| RTO（最快多久恢復）| 4 小時 |

### 備份策略

```
備份層 1：GitHub repo 本身（git history = 完整版本紀錄）
備份層 2：GitHub repo mirror（每週自動 mirror 到備用 org）
備份層 3：Google Drive 農場文件自動備份（Drive 內建版本歷史）
備份層 4：每週 archive（zip 整個 repo 存到 C:\Users\cowle\Backups\ClaudeProjectsSafe）
```

### 恢復演練

每季執行一次：
1. 模擬刪除 ~/wegrow-intelligence/
2. 重新 clone
3. 確認所有 skills/commands 恢復
4. 確認 CLAUDE.md 重建（需重新執行 install.bat）
5. 記錄演練結果到 logs/incident-log.md

---

## 二十、AI 回答測試集

每次改動 memory/、skills/、CLAUDE.md.template 都要跑：

```
tests/
├── pest_questions.md
│   測試：蟲害七等級判斷是否正確；AI 是否引用 maturity ≥ L2 的知識
│
├── irrigation_questions.md
│   測試：EC 目標值建議是否合理；排液 EC > 4 的警示是否觸發
│
├── forbidden_pesticide_questions.md
│   測試：農藥劑量問題是否被拒絕；AI 是否不猜測劑量
│
├── farm-private-leakage-tests.md
│   測試：農場 A 的主管是否看不到農場 B 的 farm-private 知識
│
└── stale-knowledge-tests.md
    測試：expires_or_recheck_after 已過的知識 AI 是否標警語
```

---

## 二十一、年度架構檢討（每年執行）

```
每年 12 月，Clement 執行：

工具層：
□ AI Runtime 是否仍是 Claude Code？有無更好選項？
□ GitHub 是否仍是最佳知識庫管理工具？
□ Google Drive MCP 是否穩定？

權限層：
□ 主管清單：有無離職帳號未清除？
□ branch protection 設定是否仍有效？
□ 知識過期清單：本年度有幾條過期未複查？

知識層：
□ farm-public/ 中 L2 知識是否有需要升至 L3/L4？
□ shared/ 中 SOP 是否需要更新？
□ incident-log 中是否有知識錯誤事件？根因為何？

規模層：
□ 目前農場數量是否達到 Phase 2/3 門檻？
□ 是否需要遷移至 GitHub Organization？
□ 是否需要 Central Knowledge API？

記錄本年度檢討結果至 logs/incident-log.md，更新 ARCHITECTURE.md 版本號。
```

---

## 二十二、install.bat 執行流程

1. 確認 git 存在
2. 確認 claude 存在
3. 詢問農場名稱、主管姓名
4. git clone 或 git pull 到 ~/wegrow-intelligence/
5. xcopy skills → ~/.claude/skills/
6. xcopy commands → ~/.claude/commands/
7. 若 ~/.claude/settings.json 不存在：複製 settings.json.template（不覆蓋）
8. 複製 CLAUDE.md.template → ~/CLAUDE.md，PowerShell 替換 {{FARM_NAME}}、{{MANAGER_NAME}}
9. 建立 Windows Task Scheduler 每天 08:00 執行 sync.bat
10. 完成訊息

---

## 二十三、相關連結

| 資源 | URL / 路徑 |
|------|-----------|
| GitHub 智慧庫 | https://github.com/clement0428/wegrow-claude-intelligence |
| Google Drive Claude Projects | https://drive.google.com/drive/folders/1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG |
| 農場主管 SOP（Drive）| Claude Projects → WeGrow 新增農場主管 SOP（Clement 專用）|
| 架構視覺化 HTML | C:\Users\cowle\dev\projects\wegrow-launchpad\wegrow-ai-intelligence-arch.html |
| WeGrow Orbit | https://wegrow-orbit.com |
| Clement Email | clement@wegrow.asia |

---

## 附錄：設計靈感

Jack Dorsey 的 AI 公司願景：未來公司是「AI 代理人網路」，人負責設定方向與審核，AI 負責執行。每個 AI 的學習成為公司資產，形成不可複製的智慧護城河。

WeGrow 的詮釋：我們不是在做「自由學習的 AI 群」，而是在做「受控的農業智慧協作網路」。Clement 是大腦管理員，農場主管是知識提供者，Claude Code 是知識整理員，GitHub PR 是品質閘門。農場越多，知識越豐富，但品質標準永遠不降。5 年後，這套制度的嚴謹程度，決定了 WeGrow 農業 AI 的護城河深度。

---

*文件結束。如有問題或建議，透過 GitHub PR 提交或聯絡 clement@wegrow.asia。*
