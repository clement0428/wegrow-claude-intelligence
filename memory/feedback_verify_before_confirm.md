---
name: Verify Before Confirming Changes
description: NEVER say a change is done without running grep/bash verification first — severe penalty rule
type: feedback
---

**RULE: 說「改好了」之前，必須先跑驗證指令，看到結果，確認數字正確，才能告訴用戶完成。**

**Why:** 多次發生「報告改好」但實際上 HTML 裡舊內容仍存在的情況。用戶非常憤怒，視為嚴重失職。「你眼睛瞎了」「通知所有 claude 視窗以後只要你說確認改好卻根本沒動時 會有嚴厲處罰」

**How to apply:**
1. 每次編輯 .py 檔後 → 必須重新執行腳本生成輸出檔
2. 對輸出檔跑 `grep -c` 確認：舊字串 = 0，新字串 > 0
3. 看到實際數字後才能回覆用戶「已完成」
4. 不能靠「理論上應該會更新」來報告完成
5. 編輯 .py 的 template 字串 ≠ 重新生成 HTML，這是兩個步驟，缺一不可
