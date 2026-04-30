# 远程文件传输工具指南

本文档汇总了所有已配置的远程文件传输工具及其用法。

## 练习环境

一个运行在 Docker 中的 Alpine Linux SSH 服务器。

| 项目 | 值 |
|------|-----|
| 地址 | `localhost:2222` |
| 用户名 | `student` |
| 密码 | `student` |
| 协议 | SFTP / SCP |
| 远程目录 | `/home/student` |

### 容器管理

```bash
docker ps | grep alpine              # 查看容器状态
docker start alpine-sshd-practice    # 启动容器
docker stop alpine-sshd-practice     # 停止容器
docker logs -f alpine-sshd-practice  # 查看日志
```

---

## 工具速查表

| 命令 | 工具 | 特点 | 面板布局 |
|------|------|------|----------|
| `termscp-lab` | termscp | 专用传输工具，类似 FileZilla | 双栏（本地 \| 远程） |
| `lftp-practice` | lftp | 命令行交互，支持后台/断点续传 | 命令行 |
| `mc-practice` | Midnight Commander | 经典双栏，Ctrl+U 交换面板 | 双栏（可交换） |
| `vifm-practice` | vifm | Vim 键位，需 sshfs 挂载远程 | 双栏 |
| `ranger-practice` | ranger | 三栏浏览，需 sshfs 挂载远程 | 三栏 |

---

## 1. termscp（推荐）

专用 SFTP/SCP 传输工具，TUI 界面最接近 FileZilla。

### 启动

```bash
termscp-lab          # 直接连接练习容器
termscp -b alpine-practice       # 通过书签连接
termscp -b alpine-practice-scp   # SCP 模式连接
```

### 按键操作

| 按键 | 功能 |
|------|------|
| `Tab` | 切换左右面板焦点 |
| `Enter` / `F5` | 传输选中文件 |
| `F1` | 帮助 |
| `F2` | 保存当前连接为书签 |
| `B` | 打开书签列表 |
| `F3` | 查看文件 |
| `F4` | 编辑文件 |
| `F7` | 新建目录 |
| `F8` / `Del` | 删除 |
| `Q` | 退出 |

### 书签配置

书签保存在 `~/Library/Application Support/termscp/bookmarks.toml`：

```toml
[bookmarks.alpine-practice]
protocol = "SFTP"
address = "localhost"
port = 2222
username = "student"
```

首次连接输入密码后，可选择保存到系统钥匙串，以后免密。

---

## 2. lftp

功能强大的命令行文件传输客户端，支持后台传输、断点续传、镜像同步。

### 启动

```bash
lftp-practice        # 通过书签连接
# 或
lftp alpine-practice
```

### 常用命令

```bash
# 连接后可用命令
ls                   # 列出远程目录
cd /path             # 切换远程目录
lcd /local/path      # 切换本地目录
get file.txt         # 下载文件
put file.txt         # 上传文件
mget files*.txt      # 下载多个文件
mirror remote local  # 同步远程到本地（下载）
mirror -R local remote  # 同步本地到远程（上传）

# 后台传输
get big.zip &        # 后台下载
jobs                 # 查看任务
wait                 # 等待任务完成
kill 1               # 终止任务

# 书签管理
bookmark list        # 列出书签
bookmark add name sftp://user@host:port  # 添加书签
```

### 书签配置

书签保存在 `~/.lftp/bookmarks`：

```
alpine-practice sftp://student@localhost:2222
```

---

## 3. Midnight Commander (mc)

经典双栏文件管理器，支持 FTP/SFTP，Ctrl+U 可交换左右面板。

### 启动

```bash
mc-practice          # 启动 mc
```

### 连接远程（SFTP）

1. 启动后，在左栏按 `F9`（菜单）
2. 选择 `Left`（或 `Right`）
3. 选择 `Shell link...`
4. 输入：`student@localhost:2222`
5. 输入密码：`student`
6. 连接成功后，该栏显示远程文件

### 按键操作

| 按键 | 功能 |
|------|------|
| `Tab` | 切换左右面板 |
| `Ctrl+U` | **交换左右面板内容** |
| `Enter` / `F5` | 复制文件（传输） |
| `F6` | 移动/重命名 |
| `F8` / `Del` | 删除 |
| `F9` | 菜单栏 |
| `F10` | 退出 |
| `Ins` / `Ctrl+T` | 选择文件 |
| `+` | 选择通配文件 |
| `\` | 反选 |
| `Alt+?` | 搜索文件 |

### 面板交换

按 `Ctrl+U` 后，左面板变远程、右面板变本地，即你习惯的布局。

---

## 4. vifm

Vim 键位的双栏文件管理器。远程功能需配合 sshfs 挂载。

### 启动

```bash
vifm-practice
```

### 基本按键

| 按键 | 功能 |
|------|------|
| `h/j/k/l` 或方向键 | 移动 |
| `Enter` | 打开文件/进入目录 |
| `Space` | 预览 |
| `dd` | 删除 |
| `yy` | 复制 |
| `pp` | 粘贴 |
| `v` | 可视选择 |
| `:` | 命令模式 |
| `q` | 退出 |

### 远程连接（需 sshfs）

macOS 需先安装 macFUSE + sshfs：

```bash
brew install --cask macfuse
brew install sshfs
```

然后挂载远程目录：

```bash
mkdir -p /tmp/alpine-practice
sshfs -p 2222 student@localhost:/home/student /tmp/alpine-practice
vifm /tmp/alpine-practice
```

卸载：

```bash
umount /tmp/alpine-practice
```

### 配置

配置文件：`~/.config/vifm/vifmrc`

---

## 5. ranger

Python 写的三栏文件管理器，界面美观，可预览图片/代码。

### 启动

```bash
ranger-practice
```

### 基本按键

| 按键 | 功能 |
|------|------|
| `h/j/k/l` 或方向键 | 移动 |
| `Enter` / `l` | 打开 |
| `H` / `L` | 后退/前进历史 |
| `Space` | 选择 |
| `yy` | 复制 |
| `dd` | 剪切 |
| `pp` | 粘贴 |
| `dD` | 删除 |
| `:` | 命令 |
| `?` | 帮助 |
| `q` | 退出 |

### 远程连接（需 sshfs）

同 vifm，先挂载：

```bash
mkdir -p /tmp/alpine-practice
sshfs -p 2222 student@localhost:/home/student /tmp/alpine-practice
ranger /tmp/alpine-practice
```

### 配置

配置文件：`~/.config/ranger/rc.conf`

---

## chezmoi 管理说明

所有配置文件均由 chezmoi 管理，换机器时自动同步。

### 配置文件位置

| 工具 | chezmoi 源文件 | 目标位置 |
|------|----------------|----------|
| termscp | `private_Library/private_Application Support/termscp/` | `~/Library/Application Support/termscp/` |
| lftp | `dot_lftp/bookmarks` | `~/.lftp/bookmarks` |
| vifm | `dot_config/vifm/vifmrc` | `~/.config/vifm/vifmrc` |
| ranger | `dot_config/ranger/rc.conf` | `~/.config/ranger/rc.conf` |
| aliases | `dot_config/dotfiles/aliases/tools.conf` | `~/.config/dotfiles/aliases/tools.conf` |

### 常用命令

```bash
chezmoi status                    # 查看状态
chezmoi diff                      # 查看变更
chezmoi apply                     # 应用所有配置
chezmoi apply ~/.config/vifm      # 应用单个目录
chezmoi add ~/.someconfig         # 添加新文件到 chezmoi
```

---

## 推荐学习路径

1. **先用 `termscp-lab`** — 最直观，熟悉 SFTP 传输
2. **再用 `lftp-practice`** — 学习命令行批量操作、镜像同步
3. **最后试 `mc-practice`** — 体验 Ctrl+U 交换面板的经典操作

---

## 扩展：添加新服务器书签

### termscp

编辑 `~/Library/Application Support/termscp/bookmarks.toml`：

```toml
[bookmarks.my-vps]
protocol = "SFTP"
address = "1.2.3.4"
port = 22
username = "root"
```

连接：`termscp -b my-vps`

### lftp

编辑 `~/.lftp/bookmarks`：

```
my-vps sftp://root@1.2.3.4:22
```

连接：`lftp my-vps`
