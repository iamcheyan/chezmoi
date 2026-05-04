# OpenCode + 智谱 (Zhipu) 配置

## 启动方式

### 方式1：直接运行启动脚本
```bash
~/.config/scripts/opencode2zhipu/launch.sh
```

### 方式2：手动设置环境变量
```bash
export ZHIPU_API_KEY=你的API_KEY
export ZHIPU_BASE_URL=https://open.bigmodel.cn/api/paas/v4
export model=glm-4.7
opencode
```

## 验证配置
启动后使用 `/status` 命令查看当前模型配置。

## 注意
- OpenCode 使用 OpenAI 兼容协议，智谱 API 支持此协议
- 默认模型: `glm-4.7`
- 配置文件: `~/.config/opencode/opencode.json`
