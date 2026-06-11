---
name: Orbit 完成定義與可見性規則
description: 永久規則：Orbit 開發「完成」的四個等級與七個 O 驗證閘門
type: feedback
---

「做好了」永遠不夠，必須分四個等級：
1. 已本機完成
2. 已推 Git
3. 已部署到 production
4. 已在 production 畫面驗證可見

只有到第 4 級才能說「完成」。

**Why:** Codex 多次說「完成」但 wegrow-orbit.com 畫面沒有更新，造成 Clement 看舊版以為沒改。

**How to apply:** 每次 UI 改動，必須附 production URL + 目標文字檢查結果 + commit hash。截圖最好。

---

## O1：Production 可見性閘門

每次說「完成」，必須驗證 `wegrow-orbit.com/#/analysis` 真實頁面 DOM 有目標文字。
沒有看到就不能說完成。

## O2：畫面版本章

WeGrow Orbit 右上角或頁腳顯示：`build: <commit_hash> / deployed_at`
讓 Clement 一眼確認載入的是最新版本。

## O3：部署狀態拆分

GitHub Actions workflow 必須拆成兩個獨立 job：
- `frontend bundle deployed: pass/fail`
- `photo storage check: pass/fail`

不能讓 field-photos Supabase bucket 未建立掩蓋前端是否上線。

## O4：強制更新提示

如果使用者分頁載入舊 bundle，頁面顯示：「偵測到新版，請重新載入」+ 重新載入按鈕。

## O5：截圖證據

每次 UI 改動最後附：
- production URL
- 目標文字檢查結果
- 截圖
- commit hash

沒截圖只能算「已推送」，不能算「已可見」。

## O6：視覺 Sentinel 測試

重要 UI 區塊加穩定標記，例如：
`data-testid="kengyi-decision-island"`
測試直接驗證容器存在，不靠模糊文字比對。

## O7：完成定義

- 禁止說「做好了」
- 必須說明目前在四個等級中的哪一級
