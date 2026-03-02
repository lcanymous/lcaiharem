#!/usr/bin/env bash
# lcaiharem setup script
# Deploys OpenClaw multi-agent config from this repo

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🦞 lcaiharem setup starting..."

# ── 1. Create agents ────────────────────────────────────────────────
AGENTS=(
  "finance:openrouter/qwen/qwen3-235b-a22b:~/.openclaw/workspace-finance"
  "calendar:openrouter/qwen/qwen3-235b-a22b:~/.openclaw/workspace-calendar"
  "news:openrouter/qwen/qwen3-235b-a22b:~/.openclaw/workspace-news"
  "code:openrouter/qwen/qwen3-235b-a22b:~/.openclaw/workspace-code"
)

IDENTITIES=(
  "finance:💰:財務管理"
  "calendar:📅:行事曆任務"
  "news:📰:新聞摘要"
  "code:💻:程式助理"
)

for entry in "${AGENTS[@]}"; do
  IFS=: read -r id model workspace <<< "$entry"
  if openclaw agents list 2>/dev/null | grep -q "^- $id"; then
    echo "  ✅ agent '$id' already exists, skipping"
  else
    echo "  ➕ Creating agent: $id"
    openclaw agents add "$id" \
      --model "$model" \
      --workspace "$workspace" \
      --non-interactive
  fi
done

# ── 2. Set identities ───────────────────────────────────────────────
for entry in "${IDENTITIES[@]}"; do
  IFS=: read -r id emoji name <<< "$entry"
  echo "  🎭 Setting identity for: $id ($emoji $name)"
  openclaw agents set-identity --agent "$id" --emoji "$emoji" --name "$name"
done

# ── 3. Copy SOUL.md files ───────────────────────────────────────────
WORKSPACES=(
  "finance:~/.openclaw/workspace-finance"
  "calendar:~/.openclaw/workspace-calendar"
  "news:~/.openclaw/workspace-news"
  "code:~/.openclaw/workspace-code"
)

for entry in "${WORKSPACES[@]}"; do
  IFS=: read -r id workspace <<< "$entry"
  workspace="${workspace/#\~/$HOME}"
  src="$SCRIPT_DIR/agents/$id/SOUL.md"
  if [ -f "$src" ]; then
    cp "$src" "$workspace/SOUL.md"
    echo "  📝 Copied SOUL.md → $workspace/"
  fi
done

echo ""
echo "✅ Agents ready. Now add your Telegram bot tokens:"
echo ""
echo "  openclaw channels add --channel telegram --account finance \\"
echo "    --name '財務管理' --token 'YOUR_FINANCE_BOT_TOKEN'"
echo ""
echo "  openclaw channels add --channel telegram --account calendar \\"
echo "    --name '行事曆任務' --token 'YOUR_CALENDAR_BOT_TOKEN'"
echo ""
echo "  openclaw channels add --channel telegram --account news \\"
echo "    --name '新聞摘要' --token 'YOUR_NEWS_BOT_TOKEN'"
echo ""
echo "  openclaw channels add --channel telegram --account code \\"
echo "    --name '程式助理' --token 'YOUR_CODE_BOT_TOKEN'"
echo ""
echo "Then restart the gateway:"
echo "  openclaw gateway stop && openclaw gateway --port 18789"
