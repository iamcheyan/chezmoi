#!/bin/bash
set -euo pipefail

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
	\. "$NVM_DIR/nvm.sh"
else
	echo "错误: 未找到 NVM" >&2
	exit 1
fi

if ! command -v claude &>/dev/null; then
	npm install -g @anthropic-ai/claude-code
fi

CLAUDE_PKG="$(npm root -g)/@anthropic-ai/claude-code"
if [ -f "$CLAUDE_PKG/install.cjs" ]; then
	node "$CLAUDE_PKG/install.cjs" 2>/dev/null || true
fi

# 从 llm.yaml 读取配置
LLM_CONFIG="$HOME/.config/secrets/llm.yaml"
if [ -f "$LLM_CONFIG" ]; then
	export ANTHROPIC_BASE_URL=$(yq e '.providers.ark-volces.base_url' "$LLM_CONFIG")
	export ANTHROPIC_API_KEY=$(yq e '.providers.ark-volces.api_key' "$LLM_CONFIG")
fi

cd "$HOME"
claude --dangerously-skip-permissions --model claude-sonnet-4-20250514
