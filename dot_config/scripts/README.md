# Claude Code 多环境启动脚本

每个子目录对应一个 API 后端，包含：

- `launch.sh` — 启动脚本，加载 `.env` 后运行 `claude`
- `encrypted_private_dot_env` — chezmoi 加密后的 `.env`
- `.env` — 明文环境变量（不提交，仅本地使用）
- `README.md` — 该环境的说明

## 新增一个环境

以 `claude2xxx` 为例：

### 1. 创建目录和 `.env`

```bash
mkdir -p ~/.config/scripts/claude2xxx
```

写入 `.env`：

```
ANTHROPIC_BASE_URL=https://xxx.com/anthropic
ANTHROPIC_API_KEY=sk-xxxxx
```

### 2. 加密

```bash
chezmoi encrypt ~/.config/scripts/claude2xxx/.env > ~/.config/scripts/claude2xxx/encrypted_private_dot_env
```

### 3. 创建 `launch.sh`

从任一现有目录复制，把 `.env` 路径改成 `claude2xxx/.env`。

### 4. 删除明文 `.env`（可选）

加密完成后原文件不再需要：

```bash
rm ~/.config/scripts/claude2xxx/.env
```

## 已有环境

| 目录 | 用途 |
|------|------|
| `claude2kimi` | Kimi API |
| `claude2xiaomi` | 小米 mimo API |
| `claude2deepseek` | DeepSeek API |
