# WeGrow 集體 AI 智慧架構 — 完整說明文件

> 版本：2026-06-11  
> 作者：Clement Lee（WeGrow 創辦人）  
> 用途：供 AI 審查、技術人員交接、農場主管理解整體設計

---

## 一、目標與背景

### 問題

WeGrow 目前管理多個草莓農場（目標規模：400 農場）。每個農場主管的電腦裝有 Claude Code（Anthropic AI 助手），但每台電腦是孤立的——沒有共用知識，沒有累積學習，農場 A 學到的解法，農場 B 不知道。

### 目標

建立「集體 AI 智慧」系統：

1. **共用大腦**：所有農場主管的 Claude Code 從同一個知識庫出發
2. **自動同步**：每次開機自動取得最新智慧
3. **知識回流**：任何主管的發現都能貢獻回共用大腦，全員受益
4. **Clement 審核**：所有新知識由 Clement 把關後才合併

### 設計靈感

Jack Dorsey 的 AI 公司願景：未來公司是「AI 代理人網路」，人負責設定方向與審核，AI 負責執行與學習。每個 AI 的學習成為公司資產，形成不可複製的智慧護城河。

---

## 二、系統架構總覽

```
┌─────────────────────────────────────────────────────────┐
│              ☁️  雲端大腦（Layer 1）                     │
│                                                         │
│  GitHub repo: clement0428/wegrow-claude-intelligence    │
│  ├── memory/     ← WeGrow 所有智慧（44 個知識檔）       │
│  ├── skills/     ← AI 技能包（人資搜尋、貢獻知識）      │
│  ├── commands/   ← slash 指令（/貢獻知識 等）           │
│  └── CLAUDE.md.template                                 │
│                                                         │
│  Google Drive: Claude Projects/農場主管/                │
│  └── {農場名稱}_project  ← 各農場專屬文件               │
└─────────────────────────────────────────────────────────┘
           ↓ 每次 session 開始 git pull        ↑ PR 提交新知識
┌─────────────────────────────────────────────────────────┐
│         👨‍🌾  各農場主管電腦（Layer 2）                   │
│                                                         │
│  Claude Code                                            │
│  ├── ~/CLAUDE.md            ← Session Start Protocol   │
│  ├── ~/.claude/skills/      ← 從 GitHub 同步           │
│  ├── ~/.claude/commands/    ← 從 GitHub 同步           │
│  └── ~/wegrow-intelligence/ ← GitHub repo clone        │
└─────────────────────────────────────────────────────────┘
           ↓ PR 送審        ↑ merge 後全員同步
┌─────────────────────────────────────────────────────────┐
│         🔒  Clement 審核層（Layer 3）                    │
│                                                         │
│  收到 PR → 確認知識正確 → merge main → 全員下次同步時更新│
└─────────────────────────────────────────────────────────┘
```

---

## 三、GitHub Repository 結構

**URL**：https://github.com/clement0428/wegrow-claude-intelligence  
**可見性**：Private（主管需被邀請為 Collaborator 才能 clone）  
**分支**：`main`（穩定版）+ `contrib/*`（主管貢獻，等待審核）

```
wegrow-claude-intelligence/
│
├── CLAUDE.md.template        # 農場主管電腦的 Claude Code 主設定（含佔位符）
├── install.bat               # 一鍵安裝腳本（Windows）
├── sync.bat                  # 每日同步腳本（Windows Task Scheduler 呼叫）
├── settings.json.template    # Claude Code 權限設定（bypassPermissions）
├── README.md                 # 安裝說明
│
├── memory/                   # WeGrow 知識庫（44 個 .md 檔）
│   ├── MEMORY.md             # 索引（所有 memory 檔的入口）
│   ├── feedback_*.md         # 工作規範（25 條 AI 行為規則）
│   ├── project_*.md          # 各專案背景（Orbit、Terra、Sales 等）
│   └── reference_*.md        # 外部資源連結（Hugreen API 等）
│
├── skills/
│   ├── 人資搜尋/SKILL.md     # HR 人才招募 skill
│   └── 貢獻知識/SKILL.md     # 農場主管貢獻新知識 skill（核心）
│
└── commands/
    ├── 貢獻知識.md           # /貢獻知識 slash 指令
    ├── 農場灌溉報價.md        # /農場灌溉報價 slash 指令
    ├── 農場灌溉評估.md        # /農場灌溉評估 slash 指令
    ├── auto-debug.md         # /auto-debug slash 指令
    ├── gmail整理.md          # /gmail整理 slash 指令
    └── wegrow-cloud-automation.md
```

---

## 四、Google Drive 結構

**根資料夾**：Claude Projects（id: `1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG`）

```
Claude Projects/
│
├── 農場主管/                              # 農場文件根資料夾（新建）
│   ├── _範本農場_project                  # 複製用範本
│   ├── 梓官農場_project                   # 農場 A 的文件（待建）
│   └── {農場名稱}_project                 # 新農場依此命名
│
├── WeGrow 新增農場主管 SOP（Clement 專用） # Clement 的操作手冊
├── 1.功能對應表                            # 所有工具/專案索引
├── WeGrow_Orbit - project
├── WeGrow_Sales - project
└── ...（其他既有文件）
```

**農場 project 文件內容**（每個農場一份）：
- 農場基本資料（地址、作物、面積、溫室數）
- 灌溉系統規格
- 重要參數（目標 EC、pH）
- 歷史蟲害紀錄
- 特殊注意事項
- Claude Code 使用紀錄（自動更新）

---

## 五、Session Start Protocol（每次對話自動執行）

每個農場主管的 `~/CLAUDE.md` 包含以下強制協議：

```markdown
## Session Start Protocol（MANDATORY）

每次新對話，Claude 必須依序：

### Step 1：同步最新智慧（git pull）
cd %USERPROFILE%\wegrow-intelligence && git pull origin main --quiet
xcopy /E /I /Y skills "%USERPROFILE%\.claude\skills" > nul
xcopy /E /I /Y commands "%USERPROFILE%\.claude\commands" > nul

### Step 2：讀取 WeGrow 記憶庫
讀取 %USERPROFILE%\wegrow-intelligence\memory\MEMORY.md

### Step 3：讀取農場專屬文件
讀取 Google Drive「Claude Projects/農場主管/{農場名稱}_project」

### Step 4：確認就緒
說「{農場名稱} 智慧已同步，我已準備好。今天有什麼需要幫忙？」
```

---

## 六、知識貢獻流程（`貢獻知識` Skill）

農場主管說：**「幫我把這個知識記錄到 WeGrow 共用大腦」**

Claude Code 自動執行：

```
1. 確認知識內容（如未說明，詢問情境/做法/結果）
   ↓
2. 分類（pest / irrigation / cultivation / equipment / operation）
   ↓
3. 建立標準 memory 檔案
   格式：{類型}_{主題}_{YYYYMMDD}.md
   內容：情境、做法、結果、Why、How to apply、注意事項
   ↓
4. 更新 memory/MEMORY.md 索引
   ↓
5. git checkout -b contrib/{日期}-{主題}
   git add + commit + push
   gh pr create --base main
   ↓
6. 回報 PR URL，告知等 Clement 審核
```

**Clement 收到 PR 後**：
- 確認知識正確 → merge main
- 全員下次 session start（git pull）即同步

---

## 七、新增農場主管 SOP（Clement 執行）

### 準備資料
- 主管姓名
- 農場名稱
- 主管 GitHub 帳號

### Step 1：加入 GitHub 協作者（2 分鐘）
```bash
gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{GitHub帳號} \
  --method PUT \
  --field permission=pull
```

### Step 2：建立 Google Drive 農場資料夾（3 分鐘）
1. Claude Projects → 農場主管 → 新增資料夾（農場名稱）
2. 複製 `_範本農場_project` 進去
3. 重新命名為 `{農場名稱}_project`
4. 填入基本資料，設定「知道連結的人可以檢視」

### Step 3：傳安裝說明給主管（1 分鐘）
主管需要：
1. 安裝 Git for Windows（https://git-scm.com）
2. 安裝 Node.js LTS（https://nodejs.org）
3. 執行：`npm install -g @anthropic-ai/claude-code`
4. 接受 GitHub 邀請 Email
5. 下載並雙擊 `install.bat`

`install.bat` 自動完成：
- clone repo 到 `~/wegrow-intelligence/`
- 複製 skills/commands 到 `~/.claude/`
- 用 PowerShell 替換 CLAUDE.md 佔位符（{{FARM_NAME}}, {{MANAGER_NAME}}）
- 設定 Windows Task Scheduler 每天 08:00 執行 `sync.bat`

### Step 4：驗收
主管開啟 Claude Code，說「你好」  
預期回應包含：「{農場名稱} 智慧已同步，我已準備好。」

---

## 八、每日自動同步機制

| 機制 | 觸發時間 | 執行內容 |
|------|----------|----------|
| Windows Task Scheduler | 每天 08:00 | `sync.bat` → git pull + xcopy skills/commands |
| Session Start Protocol | 每次開啟 Claude Code 新對話 | Claude 執行 git pull + 讀取 memory + 讀取農場文件 |

---

## 九、AI 行為規範（內嵌於 CLAUDE.md）

### 知識邊界
- 只回答 WeGrow 知識庫涵蓋的內容
- 超出範圍說：「這個問題超出 WeGrow 知識庫範圍，建議諮詢農業改良場或聯絡 Clement。」
- 禁止猜測農藥劑量、施用比例

### 蟲害判斷
- 使用 WeGrow 七等級標準（Lv.1–7）
- Lv.7 = 緊急通報 Clement

### 貢獻新知識
- 說「幫我把這個知識記錄到 WeGrow 共用大腦」即可觸發流程

---

## 十、技術決策記錄

| 決策 | 選擇 | 理由 |
|------|------|------|
| 智慧庫儲存 | GitHub private repo | 版本控制、PR 審核、免費、已有基礎 |
| 農場文件儲存 | Google Drive | 已有 MCP 整合、Claude Code 可直接讀取 |
| 同步機制 | git pull on session start + 排程 | 可靠、不依賴第三方 webhook |
| Windows only | .bat 腳本 | 所有農場主管目前使用 Windows |
| 知識審核 | GitHub PR + Clement 人工審核 | 防止低品質知識污染共用大腦 |
| 佔位符替換 | PowerShell 在 install.bat 內執行 | 避免主管需要手動編輯 CLAUDE.md |

---

## 十一、已知限制與待解決問題

| 問題 | 現況 | 建議解法 |
|------|------|----------|
| 僅支援 Windows | `.bat` 腳本 | 未來加 `install.sh` 支援 Mac |
| 貢獻者需要 GitHub 帳號 | 主管需自行申請 | 可用 GitHub CLI 批量邀請 |
| sync.bat 在電腦睡眠時不執行 | 排程可能 miss | Session Start Protocol 補救（每次對話也拉一次）|
| 私有 repo 主管需逐一邀請 | 手動 | 未來可改用 GitHub org + team |
| 農場 project 文件需手動建立 | 半自動 | 未來用 script 自動化 |
| memory/ 包含 Clement 個人記憶 | 部分資訊與農場主管無關 | 未來分拆 `shared/` 和 `clement-private/` |

---

## 十二、未來擴展路線圖

### Phase 1（現在）：建立共用大腦基礎 ✅
- GitHub repo + memory/skills/commands
- 一鍵安裝 + 每日同步
- 貢獻知識 skill + PR 審核

### Phase 2（3–6 個月）：農場 AI 代理人
- 每個農場有獨立的 AI 代理，24 小時監控感測器數據
- 自動通報蟲害、異常 EC、設備故障
- 人只需要確認決策

### Phase 3（6–12 個月）：跨農場自動學習
- 農場 A 解決的問題，自動分析是否適用農場 B
- AI 定期生成「本週全農場學習摘要」給 Clement
- 建立 WeGrow 農業知識 API

### Phase 4（12–24 個月）：知識護城河
- WeGrow 成為台灣草莓農業最大 AI 知識庫
- 400 農場數據規模無法被新進者短期複製

---

## 十三、相關連結

| 資源 | URL |
|------|-----|
| GitHub 智慧庫 | https://github.com/clement0428/wegrow-claude-intelligence |
| Google Drive Claude Projects | https://drive.google.com/drive/folders/1y0oKPZzq_5PxK09skSa7_ccQvI-B7ZtG |
| WeGrow Orbit（農場管理系統） | https://wegrow-orbit.com |
| Clement Email | clement@wegrow.asia |
| 架構視覺化圖 | `C:\Users\cowle\dev\projects\wegrow-launchpad\wegrow-ai-intelligence-arch.html` |

---

*文件結束。如有問題或建議，請透過 GitHub PR 或直接聯絡 Clement。*
