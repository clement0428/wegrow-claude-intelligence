---
name: How to Read PPTX Files
description: PPTX 讀取方法 — 解壓ZIP → 讀XML文字 → 若無文字則提取圖片 → Read tool看圖
type: feedback
---

PPTX 是 ZIP 壓縮檔。用 Python zipfile 讀取，兩步驟：

**Step 1: 先嘗試讀取文字**
```python
import zipfile, re
with zipfile.ZipFile(pptx_path, 'r') as z:
    slides = sorted([f for f in z.namelist() if f.startswith('ppt/slides/slide') and f.endswith('.xml')])
    for i, sf in enumerate(slides, 1):
        xml = z.read(sf).decode('utf-8', errors='ignore')
        texts = re.findall(r'<a:t[^>]*>([^<]+)</a:t>', xml)
        print(f"Slide {i}: {texts}")
```

**Step 2: 若投影片全是截圖/圖片（texts 都空），提取媒體圖片**
```python
import os
out_dir = r"C:\Users\cowle\Downloads\pptx_imgs"
os.makedirs(out_dir, exist_ok=True)
with zipfile.ZipFile(pptx_path, 'r') as z:
    for mf in z.namelist():
        if mf.startswith('ppt/media/'):
            fname = os.path.basename(mf)
            with open(os.path.join(out_dir, fname), 'wb') as f:
                f.write(z.read(mf))
```

**Step 3: 用 Read tool 讀圖片**
```
Read(file_path=r"C:\Users\cowle\Downloads\pptx_imgs\image1.png")
```
Claude 是多模態模型，可以直接看圖片內容。

**Why:** 用這方法成功讀取了5張截圖投影片的內容 (2026-05-23)。
**How to apply:** 每次用戶給 .pptx 都用這流程，不說「讀不到」。永久記住這個方法。
