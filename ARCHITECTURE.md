# WeGrow 集體 AI 智慧架構 — 完整說明文件

**Document version:** 2026-06-11-v2  
**Architecture owner:** Clement Lee（clement@wegrow.asia）  
**Last reviewed:** 2026-06-11  
**Change log:**  
- v2（2026-06-11）：修正 GitHub 權限矛盾、memory 分層、知識品質標準、禁止自動學習範圍、Drive 讀取說明、失敗恢復、權限模型、驗收 checklist、版本章  
- v1（2026-06-11）：初版

**Breaking changes（v1 → v2）：**
- memory/ 結構改變，原有檔案需遷移到 `memory/shared/` 或 `memory/clement-private/`
- settings.json.template 改為最小權限，移除 bypassPermissions
- 主管 GitHub 權限從 pull 改為 write（搭配 branch protection）

---

## 定位聲明（請 AI 優先閱讀）

**本系統不是讓每台農場 AI 自由學習後自動改變全體行為，而是建立一個「受審核、可追溯、分權限、可回滾」的 WeGrow 農業知識協作網路。任何跨農場共享知識必須經過來源標記、適用範圍判斷與 Clement 審核，才能進入共用大腦。**

AI 的角色是**整理與格式化知識草稿**，不是自主決定哪些知識正確或適用全體農場。

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

---

## 二、系統架構總覽

```
┌─────────────────────────────────────────────────────────────┐
│                  ☁️  雲端大腦（Layer 1）                     │
│                                                             │
│  GitHub: clement0428/wegrow-claude-intelligence (private)   │
│  ├── memory/shared/        ← 所有主管可讀的共用智慧          │
│  ├── memory/farm-public/   ← 跨農場學習（去識別化）          │
│  ├── memory/clement-private/ ← 只有 Clement 讀              │
│  ├── memory/review-pending/  ← 待審核新知識                 │
│  ├── skills/               ← AI 技能包                      │
│  └── commands/             ← slash 指令                     │
│                                                             │
│  Branch protection on main:                                 │
│  → 所有 merge 需 Clement review + approve                   │
│  → 農場主管可 push contrib/* 分支，不能直接改 main          │
│                                                             │
│  Google Drive: Claude Projects/農場主管/                    │
│  └── {農場名稱}_project  ← 農場專屬文件（僅該主管可寫）      │
└─────────────────────────────────────────────────────────────┘
       ↓ session start: git pull + 讀農場 project
       ↑ contrib/* branch → PR → Clement review → merge
┌─────────────────────────────────────────────────────────────┐
│              👨‍🌾  農場主管電腦（Layer 2）                     │
│                                                             │
│  Claude Code                                                │
│  ├── ~/CLAUDE.md              ← Session Start Protocol      │
│  ├── ~/.claude/skills/        ← 從 GitHub 同步              │
│  ├── ~/.claude/commands/      ← 從 GitHub 同步              │
│  └── ~/wegrow-intelligence/   ← GitHub clone（write 權限）  │
└─────────────────────────────────────────────────────────────┘
       ↓ PR 送審      ↑ merge 後全員下次同步時更新
┌─────────────────────────────────────────────────────────────┐
│              🔒  Clement 審核層（Layer 3）                   │
│                                                             │
│  收到 PR → 核對 metadata（來源/適用範圍/信心度/風險）        │
│  → confirm → merge main → 全員同步                          │
│  或 → request changes → 主管修改後再提                      │
└─────────────────────────────────────────────────────────────┘
```

---

## 三、GitHub Repository 結構

**URL**：https://github.com/clement0428/wegrow-claude-intelligence  
**可見性**：Private

### 分支策略

| 分支 | 誰可以寫 | 說明 |
|------|----------|------|
| `main` | 只有 Clement（透過 PR merge）| 穩定知識庫，有 branch protection |
| `contrib/{日期}-{主題}` | 農場主管 | 貢獻新知識的暫存分支 |

### Branch Protection 設定（需手動在 GitHub 設定）

```
main branch:
✅ Require a pull request before merging
✅ Require approvals: 1（Clement）
✅ Dismiss stale pull request approvals when new commits are pushed
✅ Require review from Code Owners
✅ Do not allow bypassing the above settings
```

### CODEOWNERS 檔案（repo 根目錄）

```
# 所有 memory/ 改動需要 Clement review
memory/  @clement0428

# 所有 skills/ 改動需要 Clement review
skills/  @clement0428
```

### GitHub 主管權限

主管 GitHub 帳號被設定為 **Write 權限**（可 push 分支），但 main 有 branch protection，只有 PR + Clement approve 才能 merge。

加入指令：
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
│   └── CODEOWNERS                # Clement 審核所有 memory/ 和 skills/ 改動
│
├── ARCHITECTURE.md               # 本文件
├── CLAUDE.md.template            # 農場主管電腦設定（含 {{佔位符}}）
├── install.bat                   # Windows 一鍵安裝
├── sync.bat                      # Windows 每日同步
├── settings.json.template        # Claude Code 最小權限設定（非 bypassPermissions）
├── README.md
│
├── memory/
│   ├── MEMORY.md                 # 索引（只列 shared/ 和 farm-public/ 的條目）
│   ├── shared/                   # 所有主管可讀（WeGrow 規範、SOP、品牌知識）
│   │   ├── feedback_*.md         # AI 行為規則
│   │   ├── brand_colors.md
│   │   └── reference_*.md
│   ├── farm-public/              # 跨農場學習用（已去識別化）
│   │   └── {scope}_{主題}_{YYYYMMDD}.md
│   ├── farm-private/             # 單一農場專屬（不進共用大腦）
│   │   └── {農場名稱}/
│   ├── clement-private/          # 只有 Clement / 核心 AI 可讀
│   │   ├── project_*.md
│   │   └── user_profile.md
│   └── review-pending/           # 待 Clement 審核的新知識
│       └── （貢獻知識 skill 產出的草稿放這裡等審核）
│
├── skills/
│   ├── 人資搜尋/SKILL.md
│   └── 貢獻知識/SKILL.md
│
└── commands/
    ├── 貢獻知識.md
    ├── 農場灌溉報價.md
    ├── 農場灌溉評估.md
    └── ...
```

---

## 四、Google Drive 結構與讀取說明

### 結構

```
Claude Projects/（id: 1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG）
│
├── 農場主管/
│   ├── _範本農場_project         # 複製範本
│   ├── 梓官農場_project          # 農場 A 專屬文件
│   └── {農場名稱}_project        # 新農場依此命名
│
├── WeGrow 新增農場主管 SOP（Clement 專用）
├── 1.功能對應表
└── ...（其他 Clement 專用文件）
```

### Claude Code 如何讀取 Google Drive

**使用 MCP（Model Context Protocol）Google Drive connector**，在 Claude Code session 內呼叫 `mcp__claude_ai_Google_Drive__search_files` 等工具。

| 項目 | 說明 |
|------|------|
| 整合方式 | Claude.ai 的 Google Drive MCP server（cloud-hosted）|
| 授權帳號 | clement0428@gmail.com（Clement 的 Google 帳號）|
| 主管電腦是否需要授權 | **是**：主管需用自己的 Claude.ai 帳號登入，且需有 Drive 檔案的讀取權限 |
| 農場 project 文件權限 | 設定為「知道連結的人可以檢視」，或直接分享給主管的 Google 帳號 |
| 讀取失敗時 | Claude 必須說「無法讀取農場文件，請確認 Google Drive 連線。以舊版本機記憶繼續。」不可靜默跳過 |
| 跨農場可見性 | 各農場 project 文件只分享給對應主管，不開放跨農場讀取 |

**讀取失敗時的 fallback 順序：**
1. 嘗試讀取 Google Drive 農場 project
2. 失敗 → 使用本機 `~/wegrow-intelligence/memory/farm-private/{農場名稱}/` 的快取
3. 快取也不存在 → 繼續執行，但告知主管「農場專屬文件無法讀取，部分建議可能不夠精準」

---

## 五、Session Start Protocol

每個農場主管的 `~/CLAUDE.md` 包含以下強制協議（install.bat 安裝時 `{{FARM_NAME}}` 和 `{{MANAGER_NAME}}` 會被替換）：

```markdown
## Session Start Protocol（MANDATORY — 不可跳過）

每次新對話，Claude 必須依序完成：

### Step 1：同步最新 WeGrow 智慧
執行：
  cd %USERPROFILE%\wegrow-intelligence
  git pull origin main --quiet

若 git pull 失敗（網路問題、token 過期等），必須說：
「智慧庫同步失敗（原因：{錯誤訊息}），以本機版本繼續。」
不可靜默繼續。

執行後：
  xcopy /E /I /Y skills "%USERPROFILE%\.claude\skills" > nul
  xcopy /E /I /Y commands "%USERPROFILE%\.claude\commands" > nul

### Step 2：讀取共用記憶庫
讀取 %USERPROFILE%\wegrow-intelligence\memory\MEMORY.md
（僅讀 shared/ 和 farm-public/ 索引，不讀 clement-private/）

### Step 3：讀取農場專屬文件
用 Google Drive MCP 讀取「Claude Projects/農場主管/{{FARM_NAME}}_project」
失敗時照 fallback 順序處理。

### Step 4：確認就緒
說：「{{FARM_NAME}} 智慧已同步，我已準備好。今天有什麼需要幫忙？」
```

---

## 六、知識品質標準與 Metadata

每個進入 `memory/farm-public/` 的知識檔必須包含以下 frontmatter：

```yaml
---
name: {知識標題}
description: {一行摘要}
type: farm-knowledge
scope: strawberry | irrigation | pest | equipment | operation | other
farm: {農場名稱}（貢獻來源）
applies_to: all_farms | similar_greenhouse | specific_farm_only
evidence: photo | sensor | operator_observation | experiment | external_reference
confidence: low | medium | high
risk_level: low | medium | high
reviewed_by: （等 Clement 填）
review_date: （等 Clement 填）
expires_or_recheck_after: {YYYY-MM-DD}（農業知識有季節性，須定期複查）
contributor: {主管姓名}
contributed_date: {YYYY-MM-DD}
---
```

### confidence 定義

| 等級 | 條件 |
|------|------|
| `low` | 主管口述，單次觀察，無量測數據 |
| `medium` | 多次觀察，有感測器或照片佐證 |
| `high` | 多次重複驗證，有前後數據對比，或多農場共同驗證 |

### applies_to 說明

- `all_farms`：適用所有農場（需 high confidence 才能使用此標籤）
- `similar_greenhouse`：適用類似溫室環境，Clement 審核時需指明條件
- `specific_farm_only`：只適用貢獻農場，進 farm-private/ 而非 farm-public/

---

## 七、禁止自動學習的範圍

以下內容**禁止**由 AI 自動生成、自動升級或自動推送到共用大腦：

| 禁止項目 | 原因 |
|----------|------|
| 農藥劑量、施用比例、混用建議 | 涉及食安法規，錯誤會造成法律責任 |
| 未經結果驗證的做法 | 只能進 `review-pending/`，標記 confidence: low |
| 主管口述的因果判斷 | 必須標記 evidence: operator_observation，不得自動設為 high confidence |
| AI 自身的「建議」 | AI 的輸出是建議，不能回寫成「已驗證知識」 |
| 涉及特定廠商、藥品名稱的推薦 | 需 Clement 確認合規後才能記錄 |

**貢獻知識 skill 的強制行為：**
- 所有新知識初始進入 `memory/review-pending/`，不直接進 `shared/` 或 `farm-public/`
- confidence 預設 low，主管可提升但 Claude 不可自動設為 high
- 農藥相關內容 Claude 必須拒絕整理，提示聯絡 Clement

---

## 八、知識貢獻流程（`貢獻知識` Skill）

農場主管說：**「幫我把這個知識記錄到 WeGrow 共用大腦」**

```
1. 確認知識內容
   如未說明，詢問：情境、做法、結果
   若涉及農藥劑量 → 拒絕整理，說「農藥相關需由 Clement 確認」
   ↓
2. 填寫 metadata
   scope / applies_to / evidence / confidence（預設 low）/ risk_level
   ↓
3. 建立知識草稿檔案
   位置：memory/review-pending/{scope}_{主題}_{YYYYMMDD}.md
   內容：metadata + 情境 + 做法 + 結果 + Why + How to apply + 注意事項
   ↓
4. 建立 PR 分支
   git checkout -b contrib/{YYYYMMDD}-{主題英文}
   git add memory/review-pending/...
   git commit -m "contrib({農場名稱}): {知識標題}"
   git push origin contrib/...
   ↓
5. 建立 GitHub PR
   gh pr create --base main \
     --title "[{農場名稱}] {知識標題}" \
     --body "來源：{主管}\n scope：{scope}\n confidence：low\n evidence：{evidence}\n 請 Clement 審核後決定 applies_to 範圍"
   ↓
6. 回報給主管
   顯示：PR URL + 「等 Clement 審核，審核後所有農場才會同步此知識」
```

**Clement 審核 PR 時：**
1. 確認 scope / evidence / confidence 填寫正確
2. 決定 applies_to（是否適用全農場）
3. 若適用多農場：移到 `memory/farm-public/`，填 reviewed_by + review_date + expires_or_recheck_after
4. 若只適用單一農場：移到 `memory/farm-private/{農場名稱}/`
5. 若需修改：request changes，不可直接 merge 後再改
6. merge main → 全員下次 session start 同步

---

## 九、新增農場主管 SOP（Clement 執行）

### 準備資料
- 主管姓名、農場名稱、GitHub 帳號、主管 Claude.ai 帳號

### Step 1：加入 GitHub 協作者（write 權限）
```bash
gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{GitHub帳號} \
  --method PUT \
  --field permission=write
```

### Step 2：建立 Google Drive 農場資料夾
1. Claude Projects → 農場主管 → 新增資料夾（農場名稱）
2. 複製 `_範本農場_project` 進去，命名為 `{農場名稱}_project`
3. 填入農場基本資料
4. 分享給主管的 Google 帳號（編輯者）或設「知道連結可檢視」

### Step 3：傳安裝說明給主管

> 你好，WeGrow 耕譯 AI 安裝說明：
> 1. 安裝 Git for Windows：https://git-scm.com（裝完重開電腦）
> 2. 安裝 Node.js LTS：https://nodejs.org（裝完重開電腦）
> 3. 開 cmd 執行：`npm install -g @anthropic-ai/claude-code`
> 4. 接受 GitHub 邀請 Email
> 5. 下載 install.bat 到桌面，雙擊執行，輸入農場名稱和你的名字
> 6. 開啟 Claude Code，說「你好」確認安裝成功
> 有問題：clement@wegrow.asia

### Step 4：驗收 Checklist

```
安裝驗收（主管安裝後由 Clement 確認）：
□ ~/wegrow-intelligence/ 資料夾存在
□ git log 顯示最新 commit
□ ~/.claude/skills/貢獻知識/SKILL.md 存在
□ ~/.claude/commands/貢獻知識.md 存在
□ ~/CLAUDE.md 包含正確農場名稱（非 {{FARM_NAME}}）
□ ~/CLAUDE.md 包含正確主管姓名
□ Windows 排程「WeGrow AI 智慧同步」已建立
□ Claude Code 新對話回應包含農場名稱
□ Claude Code 可讀取 memory/MEMORY.md
□ Claude Code 可讀取 Google Drive 農場 project 文件
□ /貢獻知識 可建立 PR 草稿（測試一筆測試知識）
□ sync.bat 執行後 sync.log 顯示 success 或 Already up to date.
```

### 目前主管清單（待更新）

| 農場名稱 | 主管姓名 | GitHub 帳號 | 安裝日期 | 狀態 |
|----------|----------|------------|----------|------|
| （待新增）| | | | |

---

## 十、每日自動同步機制

| 機制 | 觸發時間 | 執行內容 | 失敗處理 |
|------|----------|----------|----------|
| Windows Task Scheduler | 每天 08:00 | sync.bat → git pull + xcopy | 寫入 sync.log，不中斷電腦 |
| Session Start Protocol | 每次新對話開始 | Claude 執行 git pull + 讀 memory + 讀農場文件 | 告知主管，以舊版繼續 |

---

## 十一、失敗恢復流程

### git pull 衝突
```
原因：本機有未 commit 的改動與遠端衝突
處理：
  git stash           # 暫存本機改動
  git pull origin main
  git stash pop       # 嘗試還原
  若衝突：保留遠端版本（共用大腦優先），通知 Clement
```

### repo clone 不存在
```
原因：首次安裝失敗或資料夾被刪除
處理：
  重新執行 install.bat
  或手動：git clone https://github.com/clement0428/wegrow-claude-intelligence.git ~/wegrow-intelligence
```

### GitHub token / 認證過期
```
症狀：git pull 返回 403 或 authentication failed
處理：
  gh auth login      # 重新登入 GitHub CLI
  輸入 GitHub token（從 github.com/settings/tokens 取得）
  再執行 sync.bat
```

### sync.bat 失敗 log
```
位置：~/wegrow-intelligence/sync.log
格式：{日期時間} {成功/失敗} {錯誤訊息}
保留：最近 30 天（sync.bat 自動清理舊 log）
```

### 主管離線時
```
Claude Code 可在離線狀態使用本機的 ~/wegrow-intelligence/memory/ 知識
但無法讀取 Google Drive 農場文件
Claude 必須主動說：「目前離線，使用本機版知識庫（上次同步：{sync.log 最後成功時間}）」
```

### 回滾到上一版穩定知識庫
```bash
cd ~/wegrow-intelligence
git log --oneline -10           # 找到目標版本的 commit hash
git checkout {commit-hash}      # 切回舊版
# 通知 Clement，由 Clement 決定是否在 main 上 revert
```

---

## 十二、安全與權限模型

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
      "Edit(%USERPROFILE%/wegrow-intelligence/memory/review-pending/*)"
    ],
    "deny": [
      "Bash(rm*)",
      "Bash(git push --force*)",
      "Bash(git reset --hard*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/shared/*)",
      "Write(%USERPROFILE%/wegrow-intelligence/memory/clement-private/*)"
    ],
    "defaultMode": "allowlist"
  },
  "autoUpdatesChannel": "latest",
  "skipDangerousModePermissionPrompt": false
}
```

> ⚠️ `bypassPermissions` 只允許在 Clement 的受控測試機使用，不作為農場主管預設設定。

### memory/ 資料夾存取矩陣

| 資料夾 | 農場主管讀 | 農場主管寫 | 其他主管讀 | Clement 讀/寫 |
|--------|-----------|-----------|-----------|--------------|
| shared/ | ✅ | ❌ | ✅ | ✅ |
| farm-public/ | ✅ | ❌（透過 PR）| ✅ | ✅ |
| farm-private/{自己農場}/ | ✅ | ✅ | ❌ | ✅ |
| farm-private/{其他農場}/ | ❌ | ❌ | ❌ | ✅ |
| clement-private/ | ❌ | ❌ | ❌ | ✅ |
| review-pending/ | ✅（自己提交的）| ✅（新增）| ❌ | ✅ |

---

## 十三、install.bat 執行流程

1. 確認 git 存在
2. 確認 claude 存在
3. 詢問農場名稱、主管姓名
4. `git clone` 或 `git pull` 智慧庫到 `~/wegrow-intelligence/`
5. `xcopy` skills → `~/.claude/skills/`
6. `xcopy` commands → `~/.claude/commands/`
7. 若 `~/.claude/settings.json` 不存在：複製 `settings.json.template`（不覆蓋已有設定）
8. 複製 `CLAUDE.md.template` → `~/CLAUDE.md`，用 PowerShell 替換 `{{FARM_NAME}}` 和 `{{MANAGER_NAME}}`
9. 建立 Windows Task Scheduler「WeGrow AI 智慧同步」每天 08:00 執行 `sync.bat`
10. 顯示完成訊息

---

## 十四、相關連結

| 資源 | URL / 路徑 |
|------|-----------|
| GitHub 智慧庫 | https://github.com/clement0428/wegrow-claude-intelligence |
| Google Drive Claude Projects | https://drive.google.com/drive/folders/1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG |
| 農場主管 SOP（Drive）| Claude Projects → WeGrow 新增農場主管 SOP（Clement 專用）|
| 架構視覺化 HTML | `C:\Users\cowle\dev\projects\wegrow-launchpad\wegrow-ai-intelligence-arch.html` |
| WeGrow Orbit | https://wegrow-orbit.com |
| Clement Email | clement@wegrow.asia |

---

## 附錄：設計靈感

Jack Dorsey 的 AI 公司願景：未來公司是「AI 代理人網路」，人負責設定方向與審核，AI 負責執行。每個 AI 的學習成為公司資產，形成不可複製的智慧護城河。

WeGrow 的詮釋：我們不是在做「自由學習的 AI 群」，而是在做「受控的農業智慧協作網路」。Clement 是大腦管理員，農場主管是知識提供者，Claude Code 是知識整理員，GitHub PR 是品質閘門。農場越多，知識越豐富，但品質標準永遠不降。

---

*文件結束。如有問題或建議，請透過 GitHub PR 提交或聯絡 clement@wegrow.asia。*
