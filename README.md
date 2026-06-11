# WeGrow Claude Intelligence — 集體 AI 智慧共用大腦

每個農場主管的 Claude Code 共用這個 repo，讓所有人站在同一個智慧基礎上工作。

## 這個 repo 裡有什麼

```
memory/              ← WeGrow 累積的所有智慧（rules、SOP、知識庫）
skills/
  人資搜尋/          ← HR 人才招募 skill
  貢獻知識/          ← 農場主管貢獻新知識到共用大腦
commands/            ← slash 指令（/貢獻知識、/農場灌溉報價 等）
CLAUDE.md.template   ← 每台電腦的 Claude Code 設定（install.bat 自動替換農場名稱）
install.bat          ← 一鍵安裝（雙擊執行，5 分鐘）
sync.bat             ← 每日同步（Windows 排程每天 08:00 自動跑）
settings.json.template ← Claude Code 權限設定範本
```

## Clement：新增主管流程

參考 Google Drive → Claude Projects →「WeGrow 新增農場主管 SOP（Clement 專用）」

步驟摘要：
1. `gh api repos/clement0428/wegrow-claude-intelligence/collaborators/{帳號} --method PUT --field permission=pull`
2. Google Drive → 農場主管 資料夾 → 新增農場子資料夾 + 複製範本
3. 傳安裝說明給主管
4. 驗收：主管說「你好」，Claude 回應包含農場名稱

## 主管：一鍵安裝

1. 接受 GitHub 邀請 Email
2. 下載 `install.bat` 到桌面
3. 雙擊執行，輸入農場名稱和姓名
4. 開啟 Claude Code，完成

## 貢獻新知識

說：**「幫我把這個知識記錄到 WeGrow 共用大腦」**

Claude 自動整理 → 提交 PR → Clement 審核 → 全員同步

## Google Drive 農場文件

Claude Projects → 農場主管 → {農場名稱}_project

---
WeGrow · 讓每個農場都站在巨人的肩膀上 · github.com/clement0428/wegrow-claude-intelligence
