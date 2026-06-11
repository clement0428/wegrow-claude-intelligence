---
name: All Projects Registry Rule
description: Every newly developed skill, tool, webpage, or feature MUST be automatically added to 功能對應表.html — no exceptions
type: feedback
---

Every time a new skill, tool, HTML page, or feature is developed or completed, it MUST be immediately registered in:

`C:\Users\cowle\OneDrive\文件\Claude\Projects\1.功能對應表.html`

**Why:** Clement explicitly requested this as a standing rule so the master index always reflects the full inventory of what exists. Nothing should be "findable only if you know to look for it."

**How to apply:**
- After creating any new HTML page, Vue component, skill, or tool → open 功能對應表.html and add the appropriate row + chip link
- Add to the correct existing section if it fits; create a new `<div class="sec">` if it's a new project category
- Chip format: `<a class="chip" href="..." target="_blank">emoji 名稱</a>`
- Table row format: `<tr><td>功能類別</td><td>說明</td><td><span class="t tf">檔案名</span></td><td class="ok">✅ 完成</td></tr>`
- Also update `data-k` attribute on the section div to include relevant search keywords
- Do this in the same conversation as the work — never defer it to "later"
