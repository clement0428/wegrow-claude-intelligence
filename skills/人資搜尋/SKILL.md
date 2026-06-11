---
name: 人資搜尋
description: WeGrow HR talent acquisition skill. Use when user invokes /人資搜尋, asks to evaluate a candidate, generate outreach messages, search for talent on 104 or Yourator, or manage the candidate pipeline. Handles candidate scoring, personalized outreach in Traditional Chinese and English, and pipeline tracking via Notion.
argument-hint: [職缺類型] [候選人資料 or 動作]
allowed-tools: [Read, Write, Glob, Bash, WebSearch, WebFetch]
---

# WeGrow 人資搜尋 Skill

WeGrow 的 AI 人才招募助手。整合 104 人力銀行、Yourator 與 Claude 分析，執行候選人評估、個人化外聯、pipeline 管理。

## 呼叫方式

```
/人資搜尋                          → 顯示選單
/人資搜尋 評估 [候選人資料]         → 評分報告 + 外聯訊息
/人資搜尋 搜尋 [職缺類型]           → 搜尋 104/Yourator 相關人才
/人資搜尋 外聯 [候選人名稱/職缺]    → 生成個人化邀約訊息
/人資搜尋 pipeline                 → 查看目前候選人狀態
/人資搜尋 職缺 [職缺類型]           → 生成職缺描述（104/Yourator 格式）
```

用戶輸入的參數為：$ARGUMENTS

---

## 執行邏輯

### 無參數或顯示選單

列出所有功能選項，顯示目前 pipeline 摘要（從 Notion 或候選人庫讀取）。

---

### 動作：評估

**輸入：** 候選人的 LinkedIn/104 profile 文字、履歷摘要，或任何背景資訊。

**輸出格式：**

```
## 候選人評估報告

**姓名：** [推測或已知]
**目標職缺：** [最適合的 WeGrow 職缺]

### 評分（總分 100）

| 維度 | 分數 | 說明 |
|------|------|------|
| 技術能力 | X/40 | [具體說明技術匹配程度] |
| 農業科技適配 | X/30 | [是否有農業/IoT/精準農業背景或學習意願] |
| 使命契合度 | X/20 | [從過去經歷判斷是否被社會使命驅動] |
| 溝通與協作 | X/10 | [根據文字表達判斷] |
| **總分** | **X/100** | |

### 推薦行動
- 分數 ≥75：立即外聯，高優先
- 分數 50–74：外聯，說明成長機會
- 分數 <50：加入人才庫，半年後再評估

### 個人化外聯訊息（繁中）
[根據候選人背景客製化，引用具體的他/她的經歷，連結到 WeGrow 使命]

### Outreach Message (English)
[English version if candidate appears international or has English-language profile]

### 下一步行動
- [ ] 發送外聯訊息（建議平台：[104 站內信/LinkedIn/Email]）
- [ ] 追蹤時間：[X 天後]
- [ ] 加入 Notion 候選人庫
```

---

### 動作：搜尋

**輸入：** 職缺類型（例：IoT 工程師、農業顧問、Vue 前端）

執行步驟：
1. 用 WebSearch 搜尋 `site:104.com.tw [職缺相關關鍵字]` 及 `site:yourator.co [職缺關鍵字]`
2. 搜尋 LinkedIn 相關台灣人才（`site:linkedin.com/in [技能] Taiwan`)
3. 整理成候選人清單，每人附上：來源連結、推測技能、評估建議

**WeGrow 目標職缺關鍵字：**

| 職缺 | 104 關鍵字 | 技能關鍵字 |
|------|-----------|----------|
| IoT/嵌入式工程師 | 嵌入式系統、Raspberry Pi、韌體 | Python、MQTT、Modbus、農業科技 |
| 後端工程師 | 後端工程師、Python、FastAPI | SQLAlchemy、AWS、REST API |
| 前端工程師 | 前端工程師、Vue.js | Vue 2/3、Element UI、ECharts |
| 農業科技顧問 | 農業技術、精準農業、溫室管理 | VPD、EC、施肥、灌溉控制 |
| 業務開發 | 農業科技業務、B2B 銷售 | 農機、IoT 解決方案銷售 |

---

### 動作：外聯

生成個人化外聯訊息。必須：
1. 引用候選人**具體的**過去經歷（不要通用模板）
2. 說明這個職位如何讓他/她的技術「直接影響台灣農業」
3. 簡短（3–4 段），行動號召清晰

**WeGrow 使命文案模組（可選用）：**
- 「台灣有 76 萬農家，平均淨利率僅 2–3%。WeGrow 的 IoT 系統讓農場主精準控制每一滴水、每一克肥料。」
- 「我們的感測器已部署在 X 個溫室，AI 每 15 分鐘做一次決策，讓種植者晚上能睡好覺。」
- 「你在 [公司] 做的 [技術]，放到農業場景裡，影響的是真實的人和土地。」

---

### 動作：pipeline

從 `C:\Users\cowle\OneDrive\文件\Claude\Projects\人資招募系統\candidates.json`（若存在）讀取候選人狀態，格式化顯示：

| 姓名 | 職缺 | 評分 | 狀態 | 外聯日期 | 下一步 |
|------|------|------|------|---------|-------|

若檔案不存在，提示用戶先執行 `/人資搜尋 評估` 來建立候選人記錄。

---

### 動作：職缺

生成符合 104 人力銀行格式的職缺描述：

**結構：**
1. 職位名稱（吸引人，含農業科技元素）
2. 關於 WeGrow（使命驅動，2–3 句）
3. 你將做什麼（具體工作內容，5 點）
4. 我們需要你（必要條件 + 加分條件）
5. 我們提供（薪資範圍、彈性工作、技術成長、農業現場體驗）
6. 聯絡方式

**薪資參考（2026 台灣農業科技）：**
- IoT/後端工程師：NT$50,000–80,000/月
- 前端工程師：NT$45,000–70,000/月
- 農業顧問：NT$45,000–65,000/月
- 業務開發：NT$40,000–60,000 + 業績獎金

---

## 候選人庫格式

評估完後自動更新 `candidates.json`：

```json
{
  "candidates": [
    {
      "name": "姓名",
      "source": "104 / LinkedIn / Yourator / 推薦",
      "target_role": "職缺類型",
      "score": 85,
      "score_breakdown": {"tech": 35, "agri": 28, "mission": 16, "comm": 6},
      "status": "待外聯 / 已外聯 / 回覆中 / 面試中 / 聘用 / 不適合",
      "outreach_date": "2026-05-02",
      "follow_up_date": "2026-05-09",
      "notes": "備註",
      "profile_url": "連結"
    }
  ]
}
```
