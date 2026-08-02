# OMP (Oh My Pi) 环境变量与 API Key 管理指南

本文档记录了 `omp` 自定义 Model Provider 的 API Key 管理机制、底层原理、配置方式及日常维护说明。

---

## 1. 核心问题与解决方案原理

### 为什么之前会报 `401 Invalid API Key`？
`omp` 自定义 provider 在发起 API 请求时，**不会把 `apiKey: "OPENCODE_GO_API_KEY"` 这类字符串自动替换为同名 Shell 环境变量的值**，而是会将 `OPENCODE_GO_API_KEY` 这个变量名称作为 Bearer Token 直接发送给 OpenCode / EvoMap 服务端，从而触发 401 认证失败。

### 本次采用的解决方案
采用 **Chezmoi 模板化动态渲染** 方案：
1. **密钥隔离**：所有真实的 API Key 统一集中存储在 `~/.env`（权限 `0600`，不进 Chezmoi / Git 仓库）。
2. **Chezmoi 动态生成**：Chezmoi 维护 `private_models.yml.tmpl` 模板文件，在执行 `chezmoi apply` 时，自动解析 `~/.env` 中的真实 Key，生成最终供 `omp` 读取的 `~/.omp/agent/models.yml`。

---

## 2. 关键文件架构说明

| 文件路径 | 托管状态 | 说明 |
| :--- | :--- | :--- |
| `~/.env` | ❌ 不进 Git (权限 `0600`) | 唯一保存所有 API Key 真实值的文件 |
| `~/chezmoi/dot_omp/private_agent/private_models.yml.tmpl` | ✅ Chezmoi 源码 | models.yml 模板文件，定义了各 Provider 及其渲染逻辑 |
| `~/.omp/agent/models.yml` | 🔄 Chezmoi 渲染生成 | `omp` 运行实际读取的配置文件（包含渲染后的真实 Key 和 Header） |
| `~/chezmoi/dot_omp/private_agent/private_config.yml` | ✅ Chezmoi 源码 | `omp` 的全局系统配置与预设角色映射 (`modelRoles`) |

---

## 3. 日常配置与修改指南

### 3.1 如果需要修改或更新 API Key
1. 编辑 `~/.env` 文件：
   ```bash
   vim ~/.env
   ```
2. 更新对应 Key 的数值并保存（如 `OPENCODE_GO_API_KEY=sk-xxxx`）。
3. 运行 Chezmoi 应用配置以同步生成最新的 `models.yml`：
   ```bash
   chezmoi apply ~/.omp/agent/models.yml
   ```

### 3.2 如果需要添加新的 Provider 或 Model
1. 编辑 Chezmoi 中的模板文件：
   ```bash
   vim ~/chezmoi/dot_omp/private_agent/private_models.yml.tmpl
   ```
2. 参照已有结构添加新的 provider 配置，使用 `{{ index $env "YOUR_ENV_KEY" }}` 引用 `.env` 中的密钥。
3. 运行应用与测试：
   ```bash
   chezmoi apply ~/.omp/agent/models.yml
   omp models
   ```

---

## 4. 备份与迁移指南

### 4.1 备份
* **Dotfiles / 配置结构**：只要推送 `chezmoi` 仓库（`git push`）即可备份所有的 Provider 模板与 Config 配置。
* **API 密钥备份**：手动安全备份 `~/.env` 文件（请勿提交至公开 Git 仓库）。

### 4.2 新环境恢复步骤
在新的机器或环境中恢复 `omp` 配置时：
1. 复制你的 `.env` 到新机器的 `~/.env` 并设置安全权限：
   ```bash
   mkdir -p ~/.omp/agent
   chmod 600 ~/.env
   ```
2. 运行 chezmoi 拉取并应用配置：
   ```bash
   chezmoi apply
   ```
3. 验证功能：
   ```bash
   omp -p "hello" --model opencode-go/deepseek-v4-flash
   ```
