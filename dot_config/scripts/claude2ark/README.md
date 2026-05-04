# Claude Code + Ark (火山引擎) 配置

## 启动方式

### 方式1：直接运行启动脚本
```bash
~/.config/scripts/claude2ark/launch.sh
```

### 方方式2：手动设置环境变量
```bash
export ANTHROPIC_BASE_URL=https://ark.cn-beijing.volces.com/api/coding
export ANTHROPIC_API_KEY=你的API Key
claude --model claude-sonnet-4-20250514
```

## 验证配置
启动后输入 `/status` 确认模型已生效。

## 注意
- Ark 使用 Anthropic 兼容接口协议
- 需要通过 `--model` 参数指定模型名称
