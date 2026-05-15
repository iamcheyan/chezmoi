#!/bin/bash
set -euo pipefail

# 加载 NVM 环境
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
	\. "$NVM_DIR/nvm.sh"
else
	echo "错误: 未找到 NVM，请先安装 NVM (https://github.com/nvm-sh/nvm)" >&2
	exit 1
fi

# 如果 claude 命令不存在，则自动安装
if ! command -v claude &>/dev/null; then
	echo "claude 命令未找到，正在安装 @anthropic-ai/claude-code ..."
	npm install -g @anthropic-ai/claude-code
	echo "安装完成"
fi

# Ensure native binary is installed (postinstall may have been skipped)
CLAUDE_PKG="$(npm root -g)/@anthropic-ai/claude-code"
if [ -f "$CLAUDE_PKG/install.cjs" ]; then
	node "$CLAUDE_PKG/install.cjs" 2>/dev/null || true
fi

# 从 llm.yaml 读取配置
LLM_CONFIG="$HOME/.config/secrets/llm.yaml"
if [ -f "$LLM_CONFIG" ]; then
	export ANTHROPIC_BASE_URL=$(yq e '.providers.kimi-cn.base_url' "$LLM_CONFIG")
	export ANTHROPIC_API_KEY=$(yq e '.providers.kimi-cn.api_key' "$LLM_CONFIG")
	export ENABLE_TOOL_SEARCH=$(yq e '.profiles.claude2kimi-cn.env.ENABLE_TOOL_SEARCH // "false"' "$LLM_CONFIG")
fi
export PATH="$HOME/.npm-global/bin:$PATH"

# 启动 Claude Code
claude --dangerously-skip-permissions
