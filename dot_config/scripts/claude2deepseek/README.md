# Claude Code + xiaomimimo 配置

## 安装位置
- Claude Code: `~/.npm-global/bin/claude`
- 启动脚本: `~/.config/scripts/claude2xiaomi/launch.sh`

## 启动方式

### 方式1：直接运行启动脚本
```bash
~/.config/scripts/claude2xiaomi/launch.sh
```

### 方式2：使用 alias（推荐）
```bash
claude-xiaomi
```

### 方式3：手动设置环境变量
```bash
export ENABLE_TOOL_SEARCH=false
export ANTHROPIC_BASE_URL=https://token-plan-cn.xiaomimimo.com/anthropic
export ANTHROPIC_API_KEY=你的API Key
claude
```

## 验证配置
启动后输入 `/status` 确认模型已生效。

## 已跳过 Anthropic 默认登录流程
`~/.claude.json` 中已设置 `hasCompletedOnboarding: true`。

## 注意
由于 Claude Code 客户端的模型名称显示是写死的，即使实际调用的是 xiaomimimo API，
界面和回答中仍可能显示 "Claude Sonnet"。实际使用的模型取决于 xiaomimimo API 的转发配置。
