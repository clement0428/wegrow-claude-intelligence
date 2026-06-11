---
name: AI 助理知識範圍限制
description: WeGrow Orbit AI 只能回答既有知識庫內容，超範圍必須回「不知道」
type: feedback
---

AI 助理（AiChatWidget.vue）的 system prompt 已嚴格限制只能回答以下來源：
1. WeGrow Orbit 系統功能（施肥計畫、排液、防治、每日記錄、封存）
2. 蟲害等級 SOP（紅蜘蛛 1-5 級，含症狀密度危害%措施）
3. WeGrow 七等級訓練地圖（Lv1-7，草莓版）
4. 濃度計算 SOP（育苗室140L / 量產區2000L）
5. WeGrow 願景使命

知識來源 Google Drive：https://drive.google.com/drive/folders/1yIXRPgps2-LRTltx4nTCV9IoW3dBnCZc

**Why:** Clement 明確要求 AI 不可自行推測，超出知識庫一律回「不知道」。

**How to apply:** 每次更新 AI system prompt 或新增知識庫內容，必須同步更新 AiChatWidget.vue 的 system 字串。不可放寬「不知道」規則。
