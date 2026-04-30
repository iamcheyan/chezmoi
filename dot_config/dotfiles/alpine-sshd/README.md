# alpine-sshd

一个尽量小、适合练习 SSH 的 Alpine 容器模板。

用途：

- 练习 `ssh` 登录
- 练习密码登录和公钥登录
- 练习 `sshd_config`
- 练习端口映射和容器内用户

## 文件

- `Dockerfile`: 构建镜像
- `entrypoint.sh`: 按环境变量创建练习用户
- `sshd_config`: SSH 服务配置

## 默认账号

- 用户名：`student`
- 密码：`student`
- 端口：容器内 `22`

## 构建

```bash
cd ~/dotfiles/chezmoi/dot_config/dotfiles/alpine-sshd
docker build -t alpine-sshd-practice .
```

如果构建环境里 Alpine 的 `apk` 因 HTTPS 证书校验失败而报错，这个模板会先把 `/etc/apk/repositories` 切到 `http` 再安装依赖，目的是提高在 WSL、公司代理或自签证书环境里的可用性。

## 最小启动

```bash
docker run -d \
  --name alpine-sshd-practice \
  -p 2222:22 \
  alpine-sshd-practice
```

连接：

```bash
ssh student@localhost -p 2222
```

## 自定义用户名和密码

```bash
docker run -d \
  --name alpine-sshd-practice \
  -p 2222:22 \
  -e SSH_USER=alice \
  -e SSH_PASSWORD=alice \
  alpine-sshd-practice
```

注意：

- 容器启动时会自动把 `AllowUsers` 改成当前 `SSH_USER`

## 挂载公钥

先准备一个公钥文件，比如：

```bash
cat ~/.ssh/id_ed25519.pub
```

然后启动：

```bash
docker run -d \
  --name alpine-sshd-practice \
  -p 2222:22 \
  -v ~/.ssh/id_ed25519.pub:/authorized_keys:ro \
  -e AUTHORIZED_KEYS_FILE=/authorized_keys \
  alpine-sshd-practice
```

这样容器会把它复制到：

```text
/home/student/.ssh/authorized_keys
```

## 常用练习

1. 先用密码登录确认服务正常
2. 再切到公钥登录
3. 把 `PasswordAuthentication yes` 改成 `no`
4. 重新 build 并验证只能密钥登录
5. 试试 `sudo`
6. 试试 `sftp`

## 查看日志

```bash
docker logs -f alpine-sshd-practice
```

## 停止和删除

```bash
docker stop alpine-sshd-practice
docker rm alpine-sshd-practice
```

## 备注

这个模板偏向“练习用”，不是生产 SSH 镜像。
