---
name: AI 操作規範 (!給AI的規範.txt)
description: 10條永久規範：O1-O7 Orbit完成閘門 + 08記錄犯錯 + 09先搜世界最新 + 10覆蓋/刪除必須詢問
type: feedback
---

來源：`C:\Users\cowle\OneDrive\Desktop\AI Agent\!給AI的規範.txt`

**Why:** 用戶明確列出 AI 必須遵守的操作規範，永久適用。

**How to apply:** 每次執行任何任務前確認是否觸犯規範。

---

## O1：Production 可見性閘門
說「完成」前必須驗證 wegrow-orbit.com/#/analysis 真實頁面 DOM 有目標文字。
沒有看到就不能說完成。

## O2：畫面版本章
WeGrow Orbit 右上角或頁腳必須顯示 build hash + deployed_at，確認推的是最新版本。

## O3：部署狀態拆分
frontend bundle deployed 和 photo storage check 必須分開顯示，
不讓照片 bucket 失敗掩蓋前端部署狀態。

## O4：強制更新提示
使用者分頁載舊 bundle 時，頁面要顯示「偵測到新版，請重新載入」提示。

## O5：截圖證據
每次 UI 改動必須附：production URL + 目標文字檢查結果 + 截圖 + commit hash。
沒有截圖 = 只算「已推送」，不算「你看得到」。

## O6：視覺 Sentinel 測試
每個重要 UI 區塊加穩定標記，例如 data-testid="kengyi-decision-island"。
測試直接驗證容器存在，不靠模糊文字匹配。

## O7：完成定義（四等級）
不能說「做好了」，只能說：
- 已本機完成
- 已推 Git
- 已部署到 production
- 已在你的 production 畫面驗證可見

## 08：記錄犯錯紀錄
更新 GitHub 和 Notion 時，一起把犯錯紀錄更新上去。
每次更新功能前確認不要犯之前一樣的錯誤。

## 09：先搜索世界最新公司做法
一定有人在做，永遠先搜索再設計。

## 10：覆蓋/刪除 必須詢問
覆蓋或刪除沒有權限自行執行，必須暫停並詢問用戶。
