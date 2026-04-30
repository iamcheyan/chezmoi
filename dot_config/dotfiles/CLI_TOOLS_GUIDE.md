# CLI 工具指南

本文档汇总了所有已安装的现代化 CLI 工具及其用法。

安装命令（已执行）：

```bash
brew install eza bat dust duf lazygit delta tokei hyperfine tldr xh btop procs doggo trippy bandwhich glow mdcat fzf
```

---

## 文件浏览

### eza — 现代化 ls

```bash
eza                          # 基本列表，自带颜色
eza -la                      # 详细列表（替代 ls -la）
eza -la --git                # 显示 git 状态
eza -la --icons              # 显示文件图标（需 Nerd Font）
eza -T --level 2             # 树形显示，深度 2
eza -la --sort size          # 按大小排序
eza -la --reverse            # 反向排序
```

### bat — 带语法高亮的 cat

```bash
bat file.py                  # 语法高亮显示 Python 文件
bat --plain file.txt         # 纯文本模式（接近 cat）
bat -n file.py               # 显示行号
bat --diff file.py           # 显示 git diff 高亮
bat --list-themes            # 列出所有主题
```

与 yazi 配合：yazi 默认用 bat 作为代码预览器。

### dust — 磁盘占用分析

```bash
dust                         # 当前目录分析
dust -d 2                    # 只显示 2 层深度
dust -n 20                   # 显示前 20 个最大的
dust ~/Downloads             # 分析指定目录
dust -b                      # 不显示条形图
dust -r                      # 反向排序（最小的在前）
```

### duf — 磁盘/挂载点查看

```bash
duf                          # 所有挂载点表格
duf --only local             # 只显示本地磁盘
duf --sort filesystem        # 按文件系统排序
duf /home                    # 查看指定路径
duf --theme light            # 亮色主题
```

---

## 开发

### lazygit — TUI Git 客户端

```bash
lazygit                      # 在当前 git 仓库启动
lazygit --git-dir=/path      # 指定仓库
```

常用按键：

| 按键 | 功能 |
|------|------|
| `?` | 帮助 |
| `j/k` | 上下移动 |
| `space` | 选中文件（stage/unstage） |
| `c` | commit |
| `P` | push |
| `p` | pull |
| `d` | discard 更改 |
| `b` | 分支操作 |
| `m` | merge/rebase |
| `q` | 退出 |

### delta — Git diff 美化

已集成到 git config，git diff 自动使用。手动用法：

```bash
git diff | delta             # 美化 diff 输出
git show | delta             # 美化 commit 输出
delta --side-by-side file1 file2  # 并排对比两个文件
```

### tokei — 代码统计

```bash
tokei                        # 当前目录代码统计
tokei ~/project              # 指定目录
tokei --files                # 显示每个文件的统计
tokei --sort lines           # 按行数排序
tokei --exclude vendor/      # 排除目录
```

输出按语言分类，显示文件数、空行、注释、代码行。

### hyperfine — 性能基准测试

```bash
hyperfine 'ls -la'           # 测试单个命令
hyperfine 'ls -la' 'eza -la' # 对比两个命令
hyperfine --warmup 3 'cmd'   # 预热 3 次
hyperfine --runs 100 'cmd'   # 运行 100 次
hyperfine --export-json results.json 'cmd'
```

### tldr — 简化版 man

```bash
tldr tar                     # tar 常用示例
tldr --update                # 更新本地数据库
tldr --list                  # 列出所有可用命令
tldr -p linux docker         # 指定平台
```

### xh — 现代化 HTTP 客户端

```bash
xh httpbin.org/get           # GET 请求
xh post httpbin.org/post name=test  # POST 请求
xh -v httpbin.org/get        # 显示完整请求/响应
xh -I httpbin.org/get        # 只看响应头
xh -d httpbin.org/get        # 下载文件
xh --json post api.test.com/data foo=bar num:=42
```

比 curl 语法更直观，默认美化 JSON 输出。

---

## 系统监控

### btop — 系统资源监控

```bash
btop                         # 启动监控界面
btop --preset 0              # CPU 为主视图
btop --preset 1              # 内存为主视图
btop --preset 2              # 网络为主视图
```

按键：

| 按键 | 功能 |
|------|------|
| `1/2/3/4` | 切换预设视图 |
| `e` | 切换进程排序 |
| `f` | 搜索进程 |
| `k` | 杀掉进程 |
| `+/-` | 缩放 |
| `q` | 退出 |
| `h` | 帮助 |

### procs — 现代化 ps

```bash
procs                        # 替代 ps aux，彩色表格
procs zsh                    # 搜索含 zsh 的进程
procs --tree                 # 树形显示
procs --watch                # 实时刷新（类似 top）
procs --sortd cpu            # 按 CPU 排序降序
procs --tree --watch         # 实时树形
```

---

## 网络

### doggo — DNS 查询

```bash
doggo example.com            # A 记录查询
doggo example.com MX         # MX 记录
doggo example.com @8.8.8.8   # 指定 DNS 服务器
doggo example.com --json     # JSON 输出
doggo -x 1.1.1.1             # 反向 DNS
doggo example.com AAAA CNAME # 多类型查询
```

比 `dig` 输出更整洁，默认彩色。

### trip (trippy) — 现代化 traceroute

```bash
trip example.com             # 追踪路由
trip --protocol tcp example.com  # TCP 模式
trip --protocol udp example.com  # UDP 模式
trip --tui-preserve-screen example.com  # 保留历史
```

界面实时更新，带图表和统计信息。

### bandwhich — 网络带宽监控

```bash
sudo bandwhich               # 需要 root 权限
```

显示每个进程/连接的上传下载速度。

---

## 文档

### glow — Markdown 终端渲染

```bash
glow file.md                 # 渲染 markdown 文件
glow                         # 当前目录下找 markdown 文件
glow --pager file.md         # 分页模式
glow --style dark file.md    # 指定主题
glow -w 120 file.md          # 指定宽度
```

### mdcat — Markdown 渲染（支持 kitty 图片）

```bash
mdcat file.md                # 渲染 markdown
mdcat --no-pager file.md     # 禁用分页
mdcat --columns 100 file.md  # 指定列宽
```

与 glow 的区别：mdcat 支持 kitty 终端的图片协议，如果 markdown 里有图片可以直接显示。

---

## 搜索

### fzf — 模糊搜索

你已配置在 zsh 中，常用方式：

```bash
# 基础用法
cat file.txt | fzf           # 交互式选择行
fzf                          # 当前目录找文件

# 配合其他命令
CTRL+R                       # 搜索命令历史
CTRL+T                       # 搜索文件并插入路径
ALT+C                        # 搜索目录并 cd
```

---

## 别名推荐

可以在 `~/.config/dotfiles/aliases/tools.conf` 追加：

```bash
# ls 替代
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza -T --icons"

# cat 替代
alias cat="bat --plain --paging=never"

# du 替代
alias du="dust -d 1"

# ps 替代
alias ps="procs"
```

---

## 快速上手清单

```bash
# 1. 文件浏览
eza -la --git              # 漂亮地列出文件
dust -d 2                  # 看哪个目录占空间

# 2. 代码开发
lazygit                    # TUI git 操作
tokei                      # 统计代码量
hyperfine 'cmd1' 'cmd2'    # 对比性能

# 3. 系统监控
btop                       # 看 CPU/内存/网络
procs --tree               # 看进程树

# 4. 网络调试
doggo example.com          # DNS 查询
trip example.com           # 路由追踪
xh -v httpbin.org/get      # HTTP 请求

# 5. 文档阅读
glow README.md             # 读 markdown
tldr tar                   # 查命令示例
```
