---
name: Hugreen API 善農科技 API
description: Hugreen/善農科技 Gnome API reference used by Orbit (gnomeapi.fufluns.net, NOT exapi)
type: reference
---

**⚠️ Orbit 實際用 Gnome API，不是舊版 exapi**

## Gnome API（Orbit 現用）

**Base URL:** `https://gnomeapi.fufluns.net`
**格式:** `application/x-www-form-urlencoded;charset=UTF-8`（全部 POST form-data）
**回傳:** `{ status: 0, data: {...}, msg: "" }`

### 認證
```
POST /user/getAccessToken
Body: key=<帳號>&secret=<md5(明文密碼)>
→ { accessToken, expireTime }   // 有效 7 天
```
密碼需先 md5 → 32 位小寫 hex

LocalStorage: `hugreen_key` (帳號), `hugreen_token` (accessToken)

### 感測器端點
- `POST /gateway/getBindInfo` — 列出 gateway（gatewayType: 1=hub, 2=開關）
- `POST /hub/getBindInfo` — 列出 hub，含 lastMonitor 最新讀數（hubId 可選）

### 環控端點
- `POST /controller/getBindInfo` — 列出控制器
- `POST /controller/getDetailInfo` — 控制器詳情（controllerId: 16進制）
- `POST /machine/getBindInfo` — 列出機器（type: 0=閥門, 1=馬達）
- `POST /machine/operate` — 控制（state: 0=關/1=開/2=反轉，duration=秒，0=持續）
- `POST /machine/getOperationHistory` — 操作歷史（最多50筆）

### Sensor type 對照
| type | 感測器 | fields |
|------|--------|--------|
| 1 | EC | ECb (dS/m) |
| 2 | 土壤 | moisture%, temp°C |
| 3 | 環境 | lux, temp°C, humidity%, PAR |
| 4 | CO₂ | ppm |
| 5 | 三合一 | ECb, moisture%, temp°C |
| 6 | 風速 | m/s |
| 9 | 光照 | lux, PAR |
| 10 | 溫濕 | temp°C, humidity% |
| 13 | pH | pH |
| 14 | 稱重 | kg |
| 15 | 水錶 | m³ |

source: `C:\Users\cowle\orbit-src\src\api\hugreen.js`

---

## 舊版 API（已棄用，僅供參考）
**Base URL:** `https://exapi.fufluns.net`
Auth: GET `?secret=xxx` / POST `X-Hugreen-Secret: xxx` header
