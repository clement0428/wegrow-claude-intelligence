---
name: wegrow-terra 農電開發 Pipeline
description: wegrow-terra 系統概覽、路徑、GitHub、架構規劃
type: project
---

農電開發全流程管理系統，對應 wegrow-orbit（種植營運），terra 管土地到併網的開發 pipeline。

**Why:** 把原本的土地開發評分系統提升為完整 9 步驟農電 pipeline 管理，涵蓋：
項目規劃 → 許可申請 → 種植營運 → 併網掛表

**How to apply:** 開發 terra 功能時以這 4 大階段、9 步驟為骨幹設計模組

## 基本資訊
- **源碼路徑**: `C:\Users\cowle\terra-src\` (git repo)
- **OneDrive 舊路徑**: `C:\Users\cowle\OneDrive\文件\Claude\Projects\土地開發評分\app\` (勿再用)
- **GitHub**: https://github.com/clement0428/wegrow-terra (private)
- **Port**: 5070
- **啟動**: `cd terra-src && venv/Scripts/python run.py`

## 農電開發流程（9步驟）
1. 土地評估與規劃（饋線/水質/交通/財務）
2. 現場勘查（農業顧問/工程團隊/養殖戶訪談）
3. 種植物種與建議（物種決定/建築形式）
4. 農業許可（向政府部門申請）
5. 建築許可（向政府部門申請）
6. 使用執照（竣工取得）
7. 養殖（作物種植啟動）
8. 綠能農許（確認種植事實/地方政府核發）
9. 同意備案（取得地方政府同意）
→ 併網掛表（開始計算電力產出）

## 現有功能（初始版 commit 1139f25）
- 土地評分（11項指標，0-5分，AI自動評分）
- 地塊管理（新增/編輯/刪除/比較）
- Google Map 嵌入 + Leaflet/NLSC 地籍圖疊加
- 權重設定（/weights）
- 地籍圖上傳 + 現場照片
- 地塊比較 (/compare)

## 規劃擴充模組
- 案場 Pipeline 看板（9步驟進度追蹤）
- 許可文件管理（農業/建築/使用執照）
- 併網管理（掛表日期/電力產出）

## v2.0 完成功能（commit 1487e66）
- 12 階段 Pipeline 時間軸儀表板（Gantt 式）
- AI 文件清單生成（每階段）：呼叫 Claude API 產生文件指南
- 每階段文件勾選清單（STAGE_DOCUMENT_CHECKLIST）
- CRM 聯繫人：地主/太陽能/溫室建商/政府/銀行
- 案場任務管理（due date、overdue 警示）
- Clean SaaS 側邊欄 UI（#E2CF35 WeGrow 品牌色）
- 舊版土地評分全部保留

## 完成定義（同 O1-O8 規範）
1. 已本機完成
2. 已推 Git (github.com/clement0428/wegrow-terra)
3. 已部署（未來設定）
4. 已在 production 驗證可見
