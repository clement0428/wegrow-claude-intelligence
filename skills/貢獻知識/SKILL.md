---
name: 貢獻知識
description: WeGrow 知識貢獻 skill。當農場主管說「幫我把這個知識記錄到共用大腦」、「記錄這個發現」、「把這個存到 WeGrow 知識庫」時觸發。自動整理成標準格式、建立 memory 檔案、提交 GitHub PR 給 Clement 審核。
argument-hint: [知識內容] 或無參數（Claude 會詢問）
allowed-tools: [Read, Write, Edit, Bash, Glob]
---

# WeGrow 貢獻知識 Skill

農場主管發現新知識時，用這個 skill 把知識整理好、送到 WeGrow 共用大腦，等 Clement 審核後所有農場都能用。

## 呼叫方式

```
「幫我把這個知識記錄到 WeGrow 共用大腦」
「記錄這個蟲害解法」
「把剛才說的存起來」
/貢獻知識 [知識內容]
```

用戶輸入：$ARGUMENTS

---

## 執行流程

### Step 1：確認知識內容

如果 $ARGUMENTS 為空，詢問：
「你想記錄什麼知識？請描述：是什麼情況、你做了什麼、結果如何？」

等待用戶說明。收到後繼續 Step 2。

### Step 2：分類知識

判斷這個知識屬於哪一類：

| 類型 | 選用條件 | 檔名前綴 |
|------|----------|---------|
| `pest` | 蟲害、病害、防治、農藥 | `pest_` |
| `irrigation` | 灌溉、施肥、EC 值、排液 | `irrigation_` |
| `cultivation` | 栽培、育苗、嫁接、溫度管理 | `cultivation_` |
| `equipment` | 設備、感測器、控制器、維修 | `equipment_` |
| `operation` | 農場日常作業流程、人員管理 | `operation_` |
| `other` | 其他 | `farm_learning_` |

### Step 3：建立記憶檔案

在 `%USERPROFILE%\wegrow-intelligence\memory\` 建立新檔案。

檔名格式：`{類型前綴}{簡短主題}_{YYYYMMDD}.md`

例：`pest_薊馬防治夏季調整_20260611.md`

檔案內容格式：

```markdown
---
name: {知識標題}
description: {一行摘要，說明這個知識是什麼、對誰有用}
type: project
farm: {農場名稱}
contributor: {主管名稱}
date: {今天日期 YYYY-MM-DD}
category: {pest/irrigation/cultivation/equipment/operation/other}
---

{知識主體內容}

**情境：** {遇到什麼問題}

**做法：** {怎麼解決的}

**結果：** {效果如何}

**Why：** {為什麼有效，背後原因}

**How to apply：** {其他農場遇到類似情況時怎麼用}

**注意事項：** {有什麼要小心的地方}
```

### Step 4：更新 MEMORY.md 索引

讀取 `%USERPROFILE%\wegrow-intelligence\memory\MEMORY.md`，在最後加一行：

```
- [{知識標題}]({檔名}) — {一行摘要}
```

### Step 5：提交 GitHub PR

```bash
cd %USERPROFILE%\wegrow-intelligence

# 建立新分支（branch 名稱用日期+主題）
git checkout -b contrib/{YYYYMMDD}-{簡短主題英文}

# 加入新檔案
git add memory/{新檔名}.md memory/MEMORY.md

# commit
git commit -m "contrib({農場名稱}): {知識標題}"

# push
git push origin contrib/{分支名稱}

# 建立 PR
gh pr create \
  --title "[{農場名稱}] {知識標題}" \
  --body "## 貢獻者\n{主管名稱}（{農場名稱}）\n\n## 知識摘要\n{一行摘要}\n\n## 情境\n{情境描述}\n\n## 做法與結果\n{做法}→{結果}\n\n---\n請 Clement 審核後合併，全員即可使用此知識。" \
  --base main
```

### Step 6：回報結果

顯示：

```
✅ 知識已提交！

📄 標題：{知識標題}
📁 檔案：memory/{檔名}.md
🔗 PR：{GitHub PR URL}

Clement 審核後，所有農場的 Claude Code 下次同步時就能用這個知識。

要繼續記錄其他知識嗎？
```

---

## 錯誤處理

| 問題 | 處理方式 |
|------|----------|
| git push 失敗（未加入協作者） | 顯示：「請聯絡 Clement（clement@wegrow.asia）申請貢獻權限」 |
| gh 未登入 | 顯示：「請執行 `gh auth login` 後再試」 |
| 知識太模糊 | 繼續詢問細節，確保 Why 和 How to apply 有實質內容 |
| 重複知識 | 搜尋 memory/ 資料夾，告知「已有類似知識：{檔名}，要補充還是建新記錄？」 |
