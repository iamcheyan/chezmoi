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

set -a
source "$HOME/.config/scripts/claude2deepseek/.env"
set +a

claude --dangerously-skip-permissions
