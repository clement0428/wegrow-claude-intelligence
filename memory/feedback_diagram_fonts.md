---
name: matplotlib 架構圖字體大小
description: 圖表字體要填滿框框，不要小到看不見
type: feedback
---

所有 matplotlib 架構圖的字體必須夠大，以填滿所在框框為基準，不超出邊界即可。

**Why:** 預設 fontsize=11 在高解析度圖上小到看不見；使用者反映「自小到看不到」。

**How to apply:**
- box() 預設 fs1≥18, fs2≥14
- tank() label fontsize≥14
- motor_circ() label fontsize≥13
- note_panel 內容 fontsize≥9.5（自動 auto-fit 行距）
- 閥號碼（valve numbers）fontsize≥7
- 標題列 fontsize≥21
- 每次生成架構圖後必須用 Read 工具預覽圖片確認可讀性
- 字體縮放工具：gen_arch_diagrams.py 裡所有 fontsize 若要統一調整，用 `_scale_fonts.py` 腳本乘以 scale factor 再重新生成
