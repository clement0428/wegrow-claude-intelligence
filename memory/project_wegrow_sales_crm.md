---
name: WeGrow Sales CRM Hub
description: Flask CRM at localhost:5000 — AI Sales Command Center，96筆聯絡人，左側雙重篩選戰情清單，Prospect Execution Engine
type: project
---

**本機路徑：** `C:\Users\cowle\dev\projects\wegrow-sales\`
**GitHub：** `clement0428/wegrow-sales` (private)
**Port：** 5000
**啟動：** `python3 app.py` (用 python3，不是 python)
**最新 commit：** `11ec427`

**Why:** WeGrow 草莓/蜜瓜農場 B2B 銷售加速器，追蹤 96 筆通路/企業主管聯絡人。

**How to apply:** 新功能直接在 app.py 加 API route + command_center.html 加 UI。

---

## 現況 (2026-06-08)

### 96 筆聯絡人分群

| Channel Group | 數量 | 說明 |
|---|---|---|
| AAMA | 34 | 創業家/企業主管群（期9-12），轉換率最高 |
| 電商 | 19 | 線上農產平台（momo/i3/SUPERBUY等） |
| 大通路 | 18 | 全聯/好市多/楓康/家樂福等 |
| 農會 | 17 | 台南農會超市（含電話/地址） |
| 加工 | 5 | 躺著喝/蘿拉果醬/台啤等原料合作 |
| 市集 | 3 | 主婦聯盟/直接跟農夫買/山守現 |

AAMA stage 分布：17 有意向 / 11 已接觸 / 5 待開發 / 1 暫停

### 左側戰情清單（command_center.html）
- 雙重篩選：channel_group × grade（可組合，如 AAMA + A）
- 排序：stage priority → grade → fit_score → recency
- 卡片顯示：公司名、聯絡人、[channel tag]、[stage tag]、→ next action hint
- 搜尋：全欄位（含備注/電話）

### Prospect Execution Engine
- POST /api/ai/prospect-hunter → targets[] 含真實聯絡路由、話術草稿、D1/3/7/14追蹤計畫
- fallback/timeout 明確 banner 警告，禁用加入按鈕
- 前端 timeout: 150s

### 資料結構 data/
```
data/
├── contacts.json           # 主要聯絡人 (96筆)
├── tasks.json
├── customer_memory.json    # AI 記憶卡
├── events.jsonl
├── ai_runs.jsonl
├── daily_learning.jsonl
├── conversations/          # 實體對話記錄（LINE/email/phone/meeting）
│   └── {cid}.jsonl         # API: GET/POST /api/contacts/{cid}/conversations
├── notes/                  # 手動筆記
│   └── {cid}.jsonl         # API: GET/POST /api/contacts/{cid}/notes
├── quotes/                 # 報價記錄（手動存放）
└── imports/                # 原始匯入檔（試算表備份）
```
data/ 全部 gitignored，資料夾結構用 .gitkeep 追蹤。

### channel_group 推導邏輯
`derive_channel_group(c)` 在 app.py，每次 GET /api/contacts 動態注入：
- notes 含 'aama' → AAMA（優先）
- type='農場/合作夥伴' → 農會
- type='大型通路' → 大通路
- type='餐飲加工' → 加工
- type='ESG 企業'|'福委會' → ESG
- type='市集通路' + online keywords → 電商 | 否則 → 市集

### 重要原則
- 只做 Pipeline + next action + follow-up reminder（MVP原則）
- 不要每次改完就 deploy；local 測試，只在確認後才推 GitHub
- 所有 list/table 必須有 add + delete 按鈕

## Google Drive 文件
- Project doc: `WeGrow_Sales - project` (1zGYBPGFzAAOgQjt6sf_W6z_6swHzFcBfPtDpIMQqo3w)
