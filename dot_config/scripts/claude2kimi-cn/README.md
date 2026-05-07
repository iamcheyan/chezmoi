# Claude Code + Kimi Code (CN) 配置

## 安装位置
- Claude Code: `~/.npm-global/bin/claude`
- 启动脚本: `~/.config/scripts/claude2kimi-cn/launch.sh`

## 启动方式

### 方式1：直接运行启动脚本
```bash
~/.config/scripts/claude2kimi-cn/launch.sh
```

### 方式2：使用 alias（推荐）
```bash
claude-kimi-cn
```

### 方式3：手动设置环境变量
```bash
export ENABLE_TOOL_SEARCH=false
export ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic
export ANTHROPIC_API_KEY=你的API Key
PATH=$HOME/.npm-global/bin:$PATH claude
```

## .env 文件

```
ENABLE_TOOL_SEARCH=false
ANTHROPIC_BASE_URL=https://api.moonshot.cn/anthropic
ANTHROPIC_API_KEY=sk-xxxxx
PATH=$HOME/.npm-global/bin:$PATH
```

加密后保存为 `encrypted_private_dot_env`：

```bash
chezmoi encrypt ~/.config/scripts/claude2kimi-cn/.env > ~/.config/scripts/claude2kimi-cn/encrypted_private_dot_env
rm ~/.config/scripts/claude2kimi-cn/.env
```

## 验证配置
启动后输入 `/status` 确认模型已生效。

## 注意
由于 Claude Code 客户端的模型名称显示是写死的，即使实际调用的是 Kimi API，
界面和回答中仍可能显示 "Claude Sonnet"。实际使用的模型取决于 Kimi API 的转发配置。
