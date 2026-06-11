---
name: Claude Projects 標準路徑
description: 所有 Claude 管理的 projects 必須放在 C:\Users\cowle\OneDrive\文件\Claude\Projects，不得放在其他位置
type: feedback
---

所有 Claude Projects 的標準儲存路徑為：

```
C:\Users\cowle\OneDrive\文件\Claude\Projects
```

**Why:** Clement 明確指定此為所有 projects 的標準位置（2026-06-06）。

**How to apply:**
- 建立新專案時，一律放在此路徑下的子資料夾
- 2026-06-06 已完成搬移：所有 5 個 Flask apps 從 OneDrive 遷移到 `C:\Users\cowle\dev\projects\`，並各自建立 GitHub private repo
- 用 Bash（forward-slash 路徑）存取，因為路徑含中文字（Read/Write/Glob 工具靜默失敗）
- 正確 Bash 路徑格式：`/c/Users/cowle/OneDrive/文件/Claude/Projects/<project-name>/`
