---
name: Clement 草莓思維模型
description: Clement 的草莓決策框架 — 死亡判斷樹D1-D5、水養週期、產銷三權重；存放於 Clement 思維模型資料夾
type: project
---

Clement 的草莓決策框架已從四份 PDF 中萃取，存入 `orbit_thinking_models` localStorage，整合為 FARM AI Stage 2 診斷。

**Why:** 要讓 FARM AI 決策引擎的輸出經過 Clement 實戰框架的二次過濾，未來也會加入其他農友的思維模型。

**How to apply:** 開發 AI 分析功能時，Stage 1 = FARM 辯論引擎，Stage 2 = 思維模型庫診斷（目前只有 Clement）。

---

## 資料夾路徑

`C:\Users\cowle\OneDrive\文件\Claude\Projects\WeGrow_Orbit\Clement 思維模型`

四份 PDF：
- `2026草莓檢討.pdf` — 施肥週次協議、EC 教訓、排液EC是關鍵信號
- `AI產銷因子.pdf` — 三大 AI 權重（作物品質/市場時機/信任因子）
- `草莓死亡判斷決策數.pdf` — D1-D5 決策樹、E1-E9 環境閾值
- `草莓水養決策最佳化流程.pdf` — 階段性水養協議

---

## 核心框架摘要

### 死亡判斷樹 D1-D5（優先度最高）
- **D1**: 排液 EC > 4.0 mS/cm → 立即減施肥濃度 0.5，排液率升至 25%
- **D2**: 根域 EC > 3.5 持續 >3 天 → 強制沖洗
- **D3**: VPD < 0.3 持續 >4 小時 → 緊急通風（灰黴前兆）
- **D4**: 採收期 24h MT > 14°C 連續 3 天 → Brix 降低警告
- **D5**: 葉尖焦枯 + 高 EC → 立即停肥補水

### 水養週期（核心洞見）
- 第一花期**前**：均衡 NPK，液 EC 1.5–2.0
- 第一花期**後**：切換高鉀低氮（K:N = 2:1），液 EC 2.0–2.5
- **排液 EC > 4.0 = 甜度殺手**（尤其第一花期後）→ Brix 降 1–2°，A 級率降 15–20%

### 產銷三權重
1. 作物品質（40%）：Brix、A 級率、果重
2. 市場時機（35%）：春節溢價、採收窗口
3. 信任因子（25%）：穩定性、加盟複製、買家關係

---

## 未來擴充計畫
- 新增其他農友的思維模型（手動輸入）
- AI 推導模型：給 AI 感測器 + 作物 + 日期 → AI 推測農友決策模式
- localStorage key: `orbit_thinking_models`，格式: `{ id, name, source:'manual'|'ai_inferred', crop, active, systemPrompt, createdAt }`
