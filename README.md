# lcaiharem 🦞

LC 的個人 AI 助理艦隊 — 基於 [OpenClaw](https://openclaw.ai) 建置，透過 Telegram 操作日常任務。

## 架構概覽

| Bot | 模型 | 職責 |
|-----|------|------|
| 💬 LC 助理（主力） | Kimi K2.5 | 通用助理，預設頻道 |
| 💰 財務管理 | Qwen3-235B | 記帳、消費分析、帳單提醒 |
| 📅 行事曆任務 | Qwen3-235B | 行程管理、待辦追蹤、時間規劃 |
| 📰 新聞摘要 | Qwen3-235B | 科技/AI 新聞過濾與摘要 |
| 💻 程式助理 | Qwen3-235B | Code review、debug、架構建議 |

所有模型透過 [OpenRouter](https://openrouter.ai) 接入。

---

## 目錄結構

```
lcaiharem/
├── README.md
├── agents/
│   ├── finance/SOUL.md       # 財務管理助理人格設定
│   ├── calendar/SOUL.md      # 行事曆任務助理人格設定
│   ├── news/SOUL.md          # 新聞摘要助理人格設定
│   └── code/SOUL.md          # 程式助理人格設定
└── setup.sh                  # 快速部署腳本（見下方說明）
```

---

## 快速開始

### 前置需求
- [OpenClaw](https://openclaw.ai) 已安裝並完成初始設定
- OpenRouter API Key 已設定
- Telegram Bot tokens（透過 @BotFather 建立）

### Step 1：建立 Telegram Bot

到 Telegram 搜尋 `@BotFather`，用 `/newbot` 建立以下 4 個 Bot：

| Bot 名稱 | 用途 |
|---------|------|
| 財務管理 | `finance` agent |
| 行事曆任務 | `calendar` agent |
| 新聞摘要 | `news` agent |
| 程式助理 | `code` agent |

每個建立完成後取得 token，備用。

### Step 2：執行部署腳本

```bash
git clone https://github.com/lcanymous/lcaiharem.git
cd lcaiharem
chmod +x setup.sh
./setup.sh
```

腳本會自動建立 4 個 agents，並複製 SOUL.md 到對應 workspace。

### Step 3：綁定 Telegram Bot tokens

```bash
# 替換成你的實際 token
openclaw channels add --channel telegram --account finance \
  --name "財務管理" --token "YOUR_FINANCE_BOT_TOKEN"

openclaw channels add --channel telegram --account calendar \
  --name "行事曆任務" --token "YOUR_CALENDAR_BOT_TOKEN"

openclaw channels add --channel telegram --account news \
  --name "新聞摘要" --token "YOUR_NEWS_BOT_TOKEN"

openclaw channels add --channel telegram --account code \
  --name "程式助理" --token "YOUR_CODE_BOT_TOKEN"
```

### Step 4：綁定 Agent ↔ Channel

```bash
openclaw channels add --channel telegram --account finance  # then set binding
# 或直接編輯 ~/.openclaw/openclaw.json 的 bindings 區塊
```

詳見下方「手動 Binding 設定」。

### Step 5：重啟 Gateway

```bash
openclaw gateway stop
openclaw gateway --port 18789
```

---

## 手動 Binding 設定

在 `~/.openclaw/openclaw.json` 的 `bindings` 區塊加入：

```json
"bindings": [
  { "agentId": "main",     "match": { "channel": "telegram", "accountId": "default" } },
  { "agentId": "finance",  "match": { "channel": "telegram", "accountId": "finance" } },
  { "agentId": "calendar", "match": { "channel": "telegram", "accountId": "calendar" } },
  { "agentId": "news",     "match": { "channel": "telegram", "accountId": "news" } },
  { "agentId": "code",     "match": { "channel": "telegram", "accountId": "code" } }
]
```

---

## Agent 人格（SOUL.md）

每個 agent 的人格設定存放在 `agents/<id>/SOUL.md`。
若想更新，修改後執行：

```bash
cp agents/finance/SOUL.md ~/.openclaw/workspace-finance/SOUL.md
# 以此類推
```

或直接修改 `~/.openclaw/workspace-<id>/SOUL.md`，重啟 gateway 後生效。

---

## 驗證

```bash
# 確認所有 agents 狀態
openclaw agents list

# 確認 channels 連線
openclaw channels status --probe

# 查看即時 logs
openclaw channels logs
```

---

## 注意事項

- **不要把 bot token 提交到 git** — tokens 存在 `~/.openclaw/openclaw.json`，已排除在版控之外
- workspace 內容（對話記憶、USER.md 等）屬個人隱私，不納入此 repo
- Qwen3-235B 走 OpenRouter，費用依使用量計算，注意 `maxConcurrent` 設定

---

Built with 🦞 [OpenClaw](https://openclaw.ai) · Powered by [OpenRouter](https://openrouter.ai)
