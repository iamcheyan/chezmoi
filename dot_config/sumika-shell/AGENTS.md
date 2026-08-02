# AGENTS 指南 — Sumika Shell 用户配置目录

## 本目录是什么

`~/.config/sumika-shell/` 是 **chezmoi 管理的运行时配置目录**(chezmoi 目标)。
这里面的文件就是实际生效的配置,但**它不是配置源头**。真正的源在 chezmoi 仓库:

```
~/chezmoi/dot_config/sumika-shell/   ← 配置源(唯一可编辑的地方)
~/.config/sumika-shell/              ← 运行时副本(chezmoi apply 部署到这里)
```

## 铁律(最高优先级)

**禁止直接编辑本目录(`~/.config/sumika-shell/`)下的任何文件。**

直接改这里 = 只改了运行时副本,chezmoi 源没有同步。后果:

- 下次 `chezmoi apply` 会用源覆盖你的改动,改动丢失;
- 或 chezmoi 检测到目标与上次写入不一致,报冲突(`could not open a new TTY` 等),卡住 apply。

## 正确流程

1. 编辑 chezmoi 源目录中的源文件:
   `~/chezmoi/dot_config/sumika-shell/<file>`
   (等价于 `chezmoi edit ~/.config/sumika-shell/<file>`)
2. 运行 `chezmoi apply` 把改动同步到本目录。
3. 若需即时生效,重启对应服务——Quickshell **没有 live-reload**,
   改 QML/配置后必须手动重启:
   `~/development/OMD/bin/sumika-restart`

## 本目录内容与规则

| 条目 | 说明 |
|---|---|
| `sumika.json` | 用户统一配置(主题、bar、模块等),最常被改 |
| `hypr/*.lua` | Hyprland 用户覆盖层(bindings/input/looknfeel/autostart) |
| `quickshell/` | Quickshell 私有运行时配置 |
| `launchers/`、`scripts/` 等 | 用户自定义 launcher/脚本 |
| `voice/`、`keyboard-remap/`、`notifications/` 等 | 各模块用户配置 |

- 所有条目权限 **0644/0755,禁止 `private_` 前缀**(AGENTS.md 仓库规则)。
- 运行时状态(壁纸、主题当前值)在 `~/.local/state/sumika-shell/`,由程序生成,
  不在本目录,也不要 `chezmoi add` 进去。
- Sumika 代码与默认配置基线在 `~/development/OMD/`(git 管理),
  默认值在 `defaults/config/quickshell/config.json`。

## 判断"该改哪里"

| 要改什么 | 改哪里 |
|---|---|
| 用户个性化配置(bar 透明、主题、按键、launcher) | `~/chezmoi/dot_config/sumika-shell/` + `chezmoi apply` |
| 产品默认行为 / 代码 / QML | `~/development/OMD/`(git) |
| 运行时状态 | 不手改,由程序生成 |
