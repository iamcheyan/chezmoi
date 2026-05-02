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

# 加载环境变量
set -a
source "$HOME/.config/claude2kimi/.env"
set +a

# 启动 Claude Code
claude --dangerously-skip-permissions
