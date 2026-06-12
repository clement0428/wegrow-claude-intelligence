# WeGrow 耕譯 AI — 新電腦安裝指南

> 給農場主管的電腦安裝用。從零開始，照順序做完。

---

## 準備資料（先問 Clement 要）

- GitHub 帳號（沒有去 github.com 免費申請）
- 你的農場名稱（例：梓官農場）
- 你的名字

---

## Step 1：安裝 Git

1. 打開瀏覽器，進 https://git-scm.com
2. 點「Download for Windows」
3. 下載完雙擊安裝，**一路按 Next**，不用改任何設定
4. 安裝完 **重開電腦**

驗收：開「命令提示字元」（cmd），輸入：
```
git --version
```
看到 `git version 2.x.x` = 成功

---

## Step 2：安裝 Node.js

1. 進 https://nodejs.org
2. 點左邊「LTS」版本下載
3. 雙擊安裝，一路按 Next
4. 安裝完 **重開電腦**

驗收：開 cmd，輸入：
```
node --version
```
看到 `v22.x.x` 之類的 = 成功

---

## Step 3：安裝 Claude Code

開 cmd，貼上這行，按 Enter：
```
npm install -g @anthropic-ai/claude-code
```

等它跑完（約 1–2 分鐘）。

驗收：
```
claude --version
```
看到版本號 = 成功

---

## Step 4：安裝 GitHub CLI（gh）

1. 進 https://cli.github.com
2. 下載 Windows 版安裝包
3. 雙擊安裝，一路 Next
4. 安裝完不用重開電腦

驗收：
```
gh --version
```
看到版本號 = 成功

---

## Step 5：登入 GitHub

cmd 輸入：
```
gh auth login
```

照以下選：
```
? Where do you use GitHub?  → GitHub.com（按 Enter）
? What is your preferred protocol?  → HTTPS（按 Enter）
? Authenticate Git with your GitHub credentials?  → Yes（按 Enter）
? How would you like to authenticate?  → Login with a web browser（按 Enter）
```

瀏覽器會開啟，登入你的 GitHub 帳號，貼上 cmd 顯示的 code，按 Authorize。

回到 cmd 看到 `Logged in as {你的帳號}` = 成功

---

## Step 6：接受 Clement 的邀請

Clement 會寄一封 GitHub 邀請 Email 到你的 GitHub 帳號信箱。

打開 Email，點「Accept invitation」。

> 還沒收到 Email？請告訴 Clement 你的 GitHub 帳號，讓他補傳邀請。

---

## Step 7：下載並執行安裝程式

1. 打開以下網址（需登入 GitHub）：
   ```
   https://github.com/clement0428/wegrow-claude-intelligence/blob/main/install.bat
   ```
2. 點右上角「...」→「Download raw file」，存到**桌面**
3. 右鍵 install.bat → **「以系統管理員身分執行」**
4. 出現黑色視窗，輸入：
   - 農場名稱（例：梓官農場）按 Enter
   - 你的名字 按 Enter
5. 等它跑完，看到「安裝完成」= 成功

---

## Step 8：設定 Claude Code

第一次開 Claude Code：
```
claude
```

它會要求登入 Anthropic 帳號（claude.ai），照指示完成。

---

## Step 9：驗收

開 Claude Code，輸入：
```
你好
```

**正確回應應包含你的農場名稱**，例如：
```
梓官農場智慧已同步，我已準備好。今天有什麼需要幫忙？
```

看到農場名稱 = 安裝成功 ✅

---

## 安裝後每天自動同步

安裝程式已設定好，**每天早上 08:00 自動更新最新智慧**，不需要手動操作。

---

## 常見問題

**Q：Step 7 打開網址說「404 Not Found」**  
A：GitHub 邀請還沒接受。重做 Step 6。

**Q：cmd 說「npm 不是內部或外部命令」**  
A：Node.js 安裝後沒重開電腦。重開電腦再試。

**Q：install.bat 跑到一半說「clone 失敗」**  
A：GitHub 邀請沒接受，或 gh auth login 沒做。重做 Step 5–6。

**Q：Claude Code 說「同步失敗」**  
A：可能是網路問題或 GitHub token 過期。執行：
```
gh auth login
```
重新登入後再試。

**Q：驗收時 Claude 沒說農場名稱**  
A：聯絡 Clement：clement@wegrow.asia

---

## 安裝完成後怎麼貢獻新知識

發現有用的農場知識時，直接告訴 Claude：

> **「幫我把這個知識記錄到 WeGrow 共用大腦」**

Claude 會幫你整理好，送給 Clement 審核，通過後全部農場都能用。

---

*WeGrow 耕譯 AI · 有問題找 Clement：clement@wegrow.asia*
