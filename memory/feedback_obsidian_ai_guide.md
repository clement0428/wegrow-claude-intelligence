---
name: Obsidian AI 工作指導書
description: 所有 AI 在 Clement Obsidian Vault 新增/同步/修改 Markdown 時必須遵守的操作規範（9條規則+最終檢查清單）
type: feedback
---

處理 Clement 的 WeGrow Obsidian Vault 時，必須先遵守本規範，再動任何 Markdown。

**源文件：** `C:\Users\cowle\OneDrive\文件\Obsidian Vault\00-AI筆記規則\給其他AI的Obsidian工作指導書.md`

## 三大正式知識區

| 區域 | 放什麼 |
|---|---|
| `Wegrow-Orbit/` | 耕譯/KengYi、農場管理、EC/施肥/灌溉/環控、FARMS、Orbit技術API、production gate |
| `WeGrow-Terra/` | 土地開發、土地評分、補助申請、農電案場/地主/租約/許可/併網 |
| `Wegrow-sales/` | 客戶搜尋、轉換率、CRM、聯絡/商機/報價/追蹤 |

不要把正式筆記放在 vault 根目錄。

## AI 草稿流程

AI 每天產生的新 MD **先放 01-Inbox**，不直接進正式知識區。  
完成分類、去重、來源標註、連結後才可升級為 canonical。

**Inbox 五格：**
- `01-Inbox` — AI 原始建議
- `02-Reviewed` — 已分類未正式採納
- `03-Needs-Human-Review` — 需要 Clement 確認
- `04-Archive` — 正式吸收後的原稿
- `05-Conflict-Log` — 衝突登記

## 每份新筆記必須有的 frontmatter

```yaml
---
tags: []
category:
subcategory:
status: inbox
created:
updated:
source:
related:
---
```

`status` 可用值：`inbox` / `reviewed` / `needs-human-review` / `canonical` / `archived` / `superseded` / `rejected`

## 每份筆記必須有 AI 建議連結段落

```markdown
## AI 建議連結

- 上層分類：
- 相關筆記：
- 可能影響：
- 下一步應建立：
```

**跨區連結規則：**
- Orbit 影響案場導入、補助、土地條件 → 連到 Terra
- Terra 需要客戶追蹤、成交機率、CRM → 連到 Sales
- Sales 客戶進入試用/導入/技術評估 → 連到 Orbit

## 不確定時

放 `03-Needs-Human-Review`，並寫清楚：哪裡不確定、需要 Clement 確認什麼、可能影響哪個系統。

## 發現衝突時

**不要靜默覆蓋。** 登記到 `05-Conflict-Log`。  
衝突包括：日期不一致、數字不一致、AI建議與現場資料不一致、Notion/CRM/repo/Obsidian 內容不一致。

## 寫作規則

- 假設要標示為「假設」
- 已驗證資料要標示來源
- 不要刪除舊資料（除非 Clement 明確要求）
- 不要把錯誤草稿當成 canonical

## 子資料夾路徑（常用）

- `Wegrow-Orbit/耕譯/`、`Wegrow-Orbit/農場管理/`、`Wegrow-Orbit/技術/`、`Wegrow-Orbit/FARMS/`
- `WeGrow-Terra/土地開發/`、`WeGrow-Terra/土地評分/`、`WeGrow-Terra/補助申請/`
- `Wegrow-sales/客戶搜尋/`、`Wegrow-sales/轉換率評估/`、`Wegrow-sales/CRM/`

## 每份新筆記完整範本

```markdown
---
tags: []
category:
subcategory:
status: inbox
created:
updated:
source:
related:
---

# 筆記標題

## 上層分類

- 大類：[[../大類入口]]
- 子分類：[[子分類入口]]

## 內容


## AI 建議連結

- 上層分類：
- 相關筆記：
- 可能影響：
- 下一步應建立：

## 審核狀態

- 目前狀態：
- 是否需要 Clement 確認：
- 是否有資料衝突：

## 原始來源

-
```

## Obsidian 連結寫法

- 同子資料夾：`[[筆記名稱]]`
- 同大類跨子資料夾：`[[../子分類/筆記名稱]]`
- 跨大類：`[[../WeGrow-Terra/土地開發/土地開發]]`

**最少連結數：**
- 一般筆記：上層分類×1 + 相關筆記×1
- AI 建議/分析筆記：上層×1 + 相關×2 + 下一步×1
- 每日回報：農場/系統×1 + 記憶摘要×1 + 下一步驗證×1

## 啟動時必須先讀的五份文件

1. `00-Obsidian分類總覽.md`
2. `00-AI筆記規則/給其他AI的Obsidian工作指導書.md`
3. `00-AI筆記規則/新筆記路由規則.md`
4. `00-AI筆記規則/每日MD處理SOP.md`
5. `00-AI筆記規則/AI建議連結範本.md`

## 最終檢查清單（完成前必過）

- [ ] 放在正確大類或 AI inbox
- [ ] 有 frontmatter（含 status）
- [ ] 有上層分類連結
- [ ] 有 AI 建議連結段落（含下一步）
- [ ] 有來源
- [ ] 若不確定 → 已放 Needs-Human-Review 並說明原因
- [ ] 若有衝突 → 已登記 Conflict-Log，未覆蓋舊資料
- [ ] 完成後回報：新增/移動了哪些檔案＋哪些內容還需 Clement 確認

**Why:** Clement 建立此規範確保五年後知識仍可追溯，AI草稿不污染正式知識庫，所有 AI 工具（Claude/Codex/ChatGPT）統一執行相同流程。

**How to apply:** 每次 Claude 被要求在 Obsidian Vault 新增、修改、同步任何 MD 時，必須照此流程執行。完成後必須主動回報操作清單。
