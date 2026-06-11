請將以下 Gmail 信件處理流程執行完畢：

---

## STEP 1 — 讀取信件

請用戶提供信件內容（貼上原文或轉寄格式皆可）。若用戶已在指令後直接貼上，則直接進入 STEP 2。

等待用戶貼上信件後，從中解析以下欄位：

| 欄位 | 說明 |
|------|------|
| **寄件人姓名** | 對方全名 |
| **寄件人 Email** | 完整 email 地址 |
| **信件日期** | YYYY-MM-DD 格式 |
| **主旨** | 原始主旨 |
| **信件摘要** | 2–3 句話描述核心內容 |
| **回覆狀態** | 從以下選一：已回覆 / 待回覆 / 無需回覆 / 已婉拒 |
| **關係溫度** | 從以下選一：熱 🔥 / 溫 🌤️ / 冷 ❄️ |
| **行動項目** | 清單形式，說明下一步 |
| **建議下次跟進日** | YYYY-MM-DD（若無明確日期，依關係溫度推算：熱=7天內、溫=14天、冷=30天） |

---

## STEP 2 — 顯示解析結果

以表格形式呈現解析結果，並詢問：

1. **此人是否已在 CRM 名單中？** 若是，請輸入他的名稱或 # 編號；若是新聯絡人，回答「新增」
2. **上述解析是否有需要修正的欄位？**

等待用戶確認後進入 STEP 3。

---

## STEP 3 — 確認寫入

顯示即將寫入 Excel 的完整資訊摘要，格式如下：

```
📋 即將更新 WeGrow_投資人CRM_Master_cleaned.xlsx
━━━━━━━━━━━━━━━━━━━━━━━━━━
投資人：[名稱]  (#[編號] 或 新增)
最後聯繫日：[日期]
跟進次數：[原有次數 + 1]
回覆狀態：[狀態]
關係溫度：[溫度]
溝通過程：[日期] — [主旨摘要]（追加至現有記錄）
下次跟進日：[日期]
優先行動：[行動項目]
備注：[若有新資訊]
━━━━━━━━━━━━━━━━━━━━━━━━━━
確認寫入？(y / 修改 / 取消)
```

---

## STEP 4 — 執行寫入

用戶確認後，執行以下 Python 腳本將資料寫入 Excel：

```python
import openpyxl
from datetime import date

CRM_PATH = r'C:\Users\cowle\OneDrive\文件\Claude\Projects\投資人CRM\WeGrow_投資人CRM_Master_cleaned.xlsx'

wb = openpyxl.load_workbook(CRM_PATH)
ws = wb['📋 Master CRM']

# 欄位對應（row 2 是標題列，資料從 row 3 開始）
HEADERS = [cell.value for cell in ws[2]]
COL = {h: i+1 for i, h in enumerate(HEADERS) if h}

# 找到目標列（依投資人名稱或 # 編號）
# [由 Claude 依實際情況填入 target_row]
target_row = None
for row in ws.iter_rows(min_row=3, values_only=False):
    if row[COL['投資人/機構名稱']-1].value == TARGET_NAME:
        target_row = row[0].row
        break

if target_row:
    # 更新現有記錄
    ws.cell(target_row, COL['最後聯繫日']).value = CONTACT_DATE
    ws.cell(target_row, COL['回覆狀態']).value = REPLY_STATUS
    ws.cell(target_row, COL['關係溫度']).value = WARMTH
    ws.cell(target_row, COL['下次跟進日']).value = NEXT_FOLLOWUP
    ws.cell(target_row, COL['優先行動']).value = ACTION_ITEMS
    # 溝通過程追加
    existing = ws.cell(target_row, COL['溝通過程']).value or ''
    ws.cell(target_row, COL['溝通過程']).value = existing + f'\n{CONTACT_DATE} — {SUMMARY}'
    # 跟進次數 +1
    current_count = ws.cell(target_row, COL['跟進次數']).value or 0
    ws.cell(target_row, COL['跟進次數']).value = int(current_count) + 1
else:
    # 新增記錄（追加至最後一列）
    new_row = ws.max_row + 1
    ws.cell(new_row, COL['投資人/機構名稱']).value = TARGET_NAME
    ws.cell(new_row, COL['聯繫人']).value = CONTACT_PERSON
    ws.cell(new_row, COL['Email / 聯絡方式']).value = CONTACT_EMAIL
    ws.cell(new_row, COL['首次聯繫日']).value = CONTACT_DATE
    ws.cell(new_row, COL['最後聯繫日']).value = CONTACT_DATE
    ws.cell(new_row, COL['漏斗階段']).value = '01_探索'
    ws.cell(new_row, COL['聯繫狀態']).value = '已聯繫'
    ws.cell(new_row, COL['回覆狀態']).value = REPLY_STATUS
    ws.cell(new_row, COL['關係溫度']).value = WARMTH
    ws.cell(new_row, COL['溝通過程']).value = f'{CONTACT_DATE} — {SUMMARY}'
    ws.cell(new_row, COL['跟進次數']).value = 1
    ws.cell(new_row, COL['下次跟進日']).value = NEXT_FOLLOWUP
    ws.cell(new_row, COL['優先行動']).value = ACTION_ITEMS

wb.save(CRM_PATH)
print(f"✅ 已成功更新 {TARGET_NAME} 的 CRM 記錄")
```

執行後輸出：
- ✅ 成功訊息（含更新的列號與投資人名稱）
- 📋 更新後的該列摘要（供核對）

---

## STEP 5 — 更新跟進排程

提醒用戶：`⏰ 跟進排程` 工作表為手動維護，建議在 Excel 中同步確認下次跟進排程是否已更新。

若用戶有多封信件，詢問：「是否繼續整理下一封信件？」
