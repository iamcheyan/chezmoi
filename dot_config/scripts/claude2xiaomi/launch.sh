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

# 从 llm.yaml 读取配置
LLM_CONFIG="$HOME/.config/secrets/llm.yaml"
if [ -f "$LLM_CONFIG" ]; then
	export ANTHROPIC_BASE_URL=$(yq e '.providers.xiaomimimo.base_url' "$LLM_CONFIG")
	export ANTHROPIC_API_KEY=$(yq e '.providers.xiaomimimo.api_key' "$LLM_CONFIG")
	export ENABLE_TOOL_SEARCH=$(yq e '.profiles.claude2xiaomi.env.ENABLE_TOOL_SEARCH // "false"' "$LLM_CONFIG")
fi

claude --dangerously-skip-permissions
