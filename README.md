# lcaiharem 🦞

LC 的個人 AI 助理艦隊 — 基於 [OpenClaw](https://openclaw.ai) 建置，透過 Telegram 操作日常任務。

## Bot 艦隊

| Bot | 帳號 | 模型 | 職責 |
|-----|------|------|------|
| 💬 LC 助理 | [@techwithlcbot](https://t.me/techwithlcbot) | Kimi K2.5 | 通用助理，什麼都可以問 |
| 💰 財務管理 | [@lcfinance69_bot](https://t.me/lcfinance69_bot) | Qwen3-235B | 記帳、消費分析、帳單提醒 |
| 📅 行事曆任務 | [@lcalendar69_bot](https://t.me/lcalendar69_bot) | Qwen3-235B | 行程管理、待辦追蹤、時間規劃 |
| 📰 新聞摘要 | 待設定 | Qwen3-235B | 科技/AI 新聞過濾與摘要 |
| 💻 程式助理 | 待設定 | Qwen3-235B | Code review、debug、架構建議 |

所有模型透過 [OpenRouter](https://openrouter.ai) 接入，Gateway 跑在本機 macOS。

---

## 使用方式

### 私訊模式（已上線）

直接私訊各 bot，配對後即可使用：

```
@lcfinance69_bot  午餐 280
@lcalendar69_bot  明天下午 3 點開會記一下
@techwithlcbot    幫我查一下這段 code 有沒有問題
```

### 群組模式（已上線，需 @mention）

把 bot 加入群組，用 @mention 觸發對應 agent：

```
@lcfinance69_bot 這個月花了多少？
@lcalendar69_bot 本週還有什麼行程？
@lcfinance69_bot @lcalendar69_bot 你們要不要吵架
```

> bots 有自己的個性，吵起來會很有趣。

### 群組主動模式（進階設定）

讓 bots 不需 @mention，能看到所有訊息並主動在專業範疇回應：

1. 打開 `@BotFather`
2. `/mybots` → 選你的 bot → **Bot Settings** → **Group Privacy** → **Turn off**
3. 對每個 bot 重複一次
4. 重啟 gateway：`openclaw gateway stop && openclaw gateway install`

開啟後，你在群組說「誰可以幫我記帳？」財務助理會自己跳出來。

---

## 已知設定細節

### allowFrom 白名單

OpenClaw 預設只回應已授權的 peer。私訊 bot 後完成 pairing 即可。
群組需要把群組 chat ID 加進 `~/.openclaw/credentials/telegram-allowFrom.json`：

```json
{
  "version": 1,
  "allowFrom": [
    "你的Telegram用戶ID",
    "-你的群組chatID"
  ]
}
```

群組 chat ID 取得方式：在群組裡把任意訊息 forward 給 `@userinfobot`。

### groupPolicy

所有 bot 設為 `"open"`（接受所有群組），修改位置：`~/.openclaw/openclaw.json`。

---

## 目錄結構

```
lcaiharem/
├── README.md
├── agents/
│   ├── finance/SOUL.md       # 💰 財務管理助理人格
│   ├── calendar/SOUL.md      # 📅 行事曆任務助理人格
│   ├── news/SOUL.md          # 📰 新聞摘要助理人格
│   └── code/SOUL.md          # 💻 程式助理人格
└── setup.sh                  # 一鍵部署腳本
```

---

## 快速部署（新環境）

### 前置需求
- [OpenClaw](https://openclaw.ai) 已安裝
- OpenRouter API Key 已設定
- 4 個 Telegram Bot tokens（透過 `@BotFather` 建立）

### 步驟

```bash
git clone https://github.com/lcanymous/lcaiharem.git
cd lcaiharem
chmod +x setup.sh
./setup.sh
```

接著綁定 token：

```bash
openclaw channels add --channel telegram --account finance \
  --name "財務管理" --token "YOUR_FINANCE_BOT_TOKEN"

openclaw channels add --channel telegram --account calendar \
  --name "行事曆任務" --token "YOUR_CALENDAR_BOT_TOKEN"

openclaw channels add --channel telegram --account news \
  --name "新聞摘要" --token "YOUR_NEWS_BOT_TOKEN"

openclaw channels add --channel telegram --account code \
  --name "程式助理" --token "YOUR_CODE_BOT_TOKEN"
```

加入 bindings（在 `~/.openclaw/openclaw.json`）：

```json
"bindings": [
  { "agentId": "main",     "match": { "channel": "telegram", "accountId": "default" } },
  { "agentId": "finance",  "match": { "channel": "telegram", "accountId": "finance" } },
  { "agentId": "calendar", "match": { "channel": "telegram", "accountId": "calendar" } },
  { "agentId": "news",     "match": { "channel": "telegram", "accountId": "news" } },
  { "agentId": "code",     "match": { "channel": "telegram", "accountId": "code" } }
]
```

重啟：

```bash
openclaw gateway stop && openclaw gateway install
```

---

## 更新 Agent 人格

直接編輯 `agents/<id>/SOUL.md`，然後同步到 workspace：

```bash
cp agents/finance/SOUL.md ~/.openclaw/workspace-finance/SOUL.md
cp agents/calendar/SOUL.md ~/.openclaw/workspace-calendar/SOUL.md
cp agents/news/SOUL.md ~/.openclaw/workspace-news/SOUL.md
cp agents/code/SOUL.md ~/.openclaw/workspace-code/SOUL.md
```

重啟 gateway 後生效。

---

## 驗證

```bash
openclaw agents list --bindings   # 確認 agents 和 routing
openclaw channels status          # 確認 channels 連線狀態
```

---

## 注意事項

- **不要把 bot token 提交到 git** — 存在 `~/.openclaw/openclaw.json`，已排除在版控之外
- workspace 內容（對話記憶等）屬個人隱私，不納入此 repo
- OpenClaw gateway 跑在本機，Mac 要開著 bot 才能動
- Qwen3-235B 走 OpenRouter 按量計費，注意 `maxConcurrent` 設定（預設 4）

---

Built with 🦞 [OpenClaw](https://openclaw.ai) · Powered by [OpenRouter](https://openrouter.ai)
