# 鹏芯元创官网 - 生产环境部署指南

本指南面向零基础用户，详细说明如何将官网部署到云服务器并配置 HTTPS。

---

## 目录

1. [准备工作](#1-准备工作)
2. [本地构建](#2-本地构建)
3. [上传到服务器](#3-上传到服务器)
   - [3.1 方法一：使用 FTP 工具（推荐新手）](#31-方法一使用-ftp-工具推荐新手)
   - [3.2 方法二：使用 scp 命令](#32-方法二使用-scp-命令)
   - [3.3 方法三：使用 GitHub（推荐）](#33-方法三使用-github推荐)
4. [服务器部署](#4-服务器部署)
5. [配置 HTTPS](#5-配置-https)
6. [自动续期设置](#6-自动续期设置)
7. [日常运维](#7-日常运维)
8. [常见问题](#8-常见问题)

---

## 1. 准备工作

### 1.1 服务器购买与配置

**推荐配置：**
- 云服务器：阿里云、腾讯云、华为云等
- 操作系统：Ubuntu 22.04 LTS（推荐）或 CentOS 7/8
- 最低配置：1核 2GB 内存（官网足够）
- 带宽：1Mbps 以上

**安全组开放端口：**
- 80（HTTP）
- 443（HTTPS）
- 22（SSH，远程登录用）

### 1.2 域名准备

1. 购买域名：`pxcore.com.cn`
2. 登录域名控制台，添加域名解析：
   - 记录类型：A
   - 主机记录：`www` 和 `@`
   - 记录值：你的服务器公网 IP
3. 等待生效（通常几分钟到几小时）

### 1.3 服务器远程登录

**Windows 用户：**

1. 下载安装 [PuTTY](https://www.putty.org/) 或使用 Windows Terminal
2. 获取服务器 IP、用户名（通常是 `root`）、密码
3. 连接方式（PuTTY）：
   - Host Name：输入服务器 IP
   - Port：22
   - Connection type：SSH
   - 点击 Open，输入密码（输入时不可见，输入完按回车）

**Mac/Linux 用户：**

打开终端，执行：
```bash
ssh root@你的服务器IP
# 输入密码
```

---

## 2. 本地构建

### 2.1 安装必要软件

**Windows：**

1. 安装 [Node.js](https://nodejs.org/)（选择 LTS 版本，推荐 18 或 20）
   - 下载后双击安装，全部默认即可
2. 安装完成后，打开命令提示符（Win+R，输入 cmd，回车）
3. 验证安装：
   ```cmd
   node -v
   npm -v
   ```

**Mac：**

```bash
# 使用 Homebrew 安装
brew install node

# 或下载安装包：https://nodejs.org/
```

### 2.2 获取项目代码

**方式一：从 GitHub 克隆（推荐）**

```bash
# 克隆仓库
git clone https://github.com/shilei2024/pxcore-website.git

# 进入项目目录
cd pxcore
```

**方式二：本地已有完整文件夹**

确保你有完整的 `site` 文件夹，内容包括：
```
site/
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── deploy.sh
├── src/
├── public/
├── package.json
└── ...
```

### 2.3 本地构建

打开终端（Windows 用 CMD 或 PowerShell）：

```bash
# 进入项目目录（请替换为你的实际路径）
cd d:\cursor-project\Website\site

# 安装依赖
npm install

# 构建生产版本
npm run build
```

**成功标志：**
- 看到 `Complete!` 或 `Build complete!`
- 目录下生成 `dist/` 文件夹

---

## 3. 上传到服务器

### 3.1 方法一：使用 FTP 工具（推荐新手）

**工具下载：**
- [FileZilla](https://filezilla-project.org/)（免费）

**操作步骤：**
1. 下载安装 FileZilla
2. 打开：文件 → 站点管理器 → 新建站点
3. 填写：
   - 主机：你的服务器 IP
   - 协议：SFTP
   - 登录类型：正常
   - 用户：`root`
   - 密码：你的服务器密码
4. 点击连接
5. 左侧选本地文件夹（`d:\cursor-project\Website\site`）
6. 右侧选远程文件夹（如 `/data/www/pxcore`）
7. 全部选中右侧文件，右键 → 上传

### 3.2 方法二：使用 scp 命令（Windows/Mac）

**Windows PowerShell：**
```powershell
# 替换 IP 和路径后执行
scp -r "d:\cursor-project\Website\site" root@你的服务器IP:/data/www/pxcore
# 输入密码
```

**Mac/Linux 终端：**
```bash
scp -r /path/to/site root@你的服务器IP:/data/www/pxcore
```

### 3.3 方法三：使用 GitHub（推荐）

本项目已托管在 GitHub，推荐使用 Git 进行版本管理和部署。

#### 3.3.1 首次部署（从 GitHub 克隆到服务器）

```bash
# 1. 安装 Git
apt update && apt install git -y

# 2. 进入部署目录
cd /data/www

# 3. 克隆仓库
git clone https://github.com/shilei2024/pxcore-website.git

# 4. 进入项目目录
cd pxcore

# 5. 首次部署
./deploy.sh
```

#### 3.3.2 本地修改后同步到服务器

**方式一：本地推送 → 服务器拉取（推荐）**

```bash
# 本地（你的电脑）：
# 1. 修改代码后提交并推送到 GitHub
cd d:\cursor-project\Website\site
git add .
git commit -m "feat: 修改说明"
git push

# 服务器（SSH 登录后）：
cd /data/www/pxcore
git pull
./deploy.sh
```

**方式二：FTP 上传后重新构建**

```bash
# 本地修改后，用 FTP 上传更新后的文件到服务器 /data/www/pxcore/
# 然后在服务器执行：
cd /data/www/pxcore
./deploy.sh
```

#### 3.3.3 GitHub 代码推送流程

**本地操作（你的电脑）：**

```bash
# 1. 进入项目目录
cd d:\cursor-project\Website\site

# 2. 查看修改状态
git status

# 3. 添加修改的文件
git add .

# 4. 提交修改
git commit -m "feat: 修改说明"

# 5. 推送到 GitHub
git push
```

**认证方式：**

GitHub 从 2021 年起不再支持密码认证，需要使用 Personal Access Token：

1. 访问：https://github.com/settings/tokens
2. 点击 **Generate new token (classic)**
3. Note 填：`pxcore-website`
4. Expiration 选：**No expiration**
5. 勾选 **repo**
6. 点击 **Generate token**
7. **复制 Token**（只显示一次！）

推送时：
- Username：你的 GitHub 用户名
- Password：粘贴生成的 Token

---

## 4. 服务器部署

### 4.1 安装 Docker

**Ubuntu 系统：**
```bash
# 更新软件包
apt update && apt upgrade -y

# 安装必要工具
apt install -y apt-transport-https ca-certificates curl software-properties-common

# 添加 Docker 官方 GPG 密钥
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加 Docker 仓库
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker
apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 验证安装
docker --version
docker compose version
```

**CentOS 系统：**
```bash
# 安装必要工具
yum install -y yum-utils

# 添加 Docker 仓库
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 安装 Docker
yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动 Docker
systemctl start docker
systemctl enable docker

# 验证
docker --version
```

### 4.2 创建部署目录

```bash
# 创建目录
mkdir -p /data/www/pxcore
cd /data/www/pxcore

# 确保文件已上传（检查）
ls -la
```

### 4.3 一键部署

```bash
# 赋予执行权限
chmod +x deploy.sh

# 执行部署
./deploy.sh
```

**等待完成...**

**成功标志：**
- 看到 `Done` 或类似提示
- 无报错信息

### 4.4 验证部署

**检查容器运行状态：**
```bash
docker compose ps
```

正常应显示：
```
NAME      IMAGE           COMMAND              SERVICE    CREATED   STATUS
pxcore-   site-web-1     "/docker-entryp…"   web        ...       Up
pxcore-   site-certbot-1 "/certbot"          certbot    ...       Up (idle)
```

**测试 HTTP 访问：**
```bash
# 在本地浏览器打开
http://www.pxcore.com.cn
```

如果能看到官网首页，说明部署成功！

---

## 5. 配置 HTTPS

### 5.1 申请 SSL 证书

**重要：先确保**：
1. 域名已解析到服务器 IP
2. 服务器 80 端口已开放
3. 网站已通过 HTTP 正常访问

**执行证书申请：**
```bash
cd /data/www/pxcore

# 申请证书（替换为你的邮箱）
docker compose run --rm certbot certonly \
  --webroot -w /var/www/certbot \
  -d www.pxcore.com.cn -d pxcore.com.cn \
  --email admin@pxcore.com.cn --agree-tos --no-eff-email
```

**参数说明：**
- `--email`：你的邮箱（用于证书到期提醒）
- `-d`：你的域名（可以添加多个）
- `--agree-tos`：同意服务条款
- `--no-eff-email`：不同意分享邮箱给 EFF

**成功标志：**
```
Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/www.pxcore.com.cn/fullchain.pem
```

### 5.2 重启服务加载证书

```bash
docker compose up -d --build
```

### 5.3 验证 HTTPS

在浏览器打开：
```
https://www.pxcore.com.cn
```

地址栏应显示锁形图标，表示连接安全。

---

## 6. 自动续期设置

Let's Encrypt 证书有效期为 90 天，需要自动续期。

### 6.1 测试续期命令

```bash
cd /data/www/pxcore

# 模拟续期（不实际操作）
docker compose run --rm certbot renew --dry-run
```

### 6.2 设置定时任务

```bash
# 编辑定时任务
crontab -e
```

**第一次会询问使用哪个编辑器，选择 `nano`（按 1）或 `vim`（按 2）**

在文件末尾添加：

```bash
# 每天凌晨2点检查续期，3点执行（随机避开高峰）
0 2 * * * cd /data/www/pxcore && docker compose run --rm certbot renew --quiet && docker compose exec web nginx -s reload
```

**解释：**
- `0 2 * * *`：每天凌晨 2 点执行
- `cd /data/www/pxcore`：进入项目目录
- `docker compose run --rm certbot renew --quiet`：续期检查
- `docker compose exec web nginx -s reload`：重载 Nginx

### 6.3 保存退出

**nano 编辑器：**
按 `Ctrl+X`，按 `Y` 确认，按 `Enter` 保存

**vim 编辑器：**
按 `Esc`，输入 `:wq`，按 `Enter`

### 6.4 验证定时任务

```bash
# 查看已设置的定时任务
crontab -l
```

---

## 7. 日常运维

### 7.1 查看网站状态

```bash
cd /data/www/pxcore
docker compose ps
```

### 7.2 查看日志

```bash
# 实时查看日志
docker compose logs -f

# 只看最近100行
docker compose logs --tail 100 -f
```

### 7.3 重启服务

```bash
cd /data/www/pxcore
docker compose restart
```

### 7.4 更新网站

**方式一：从 GitHub 拉取最新代码（推荐）**

```bash
cd /data/www/pxcore
git pull
./deploy.sh
```

**方式二：FTP 上传后重新构建**

```bash
# 本地修改后，用 FTP 上传更新后的文件到服务器 /data/www/pxcore/
# 然后在服务器执行：
cd /data/www/pxcore
./deploy.sh
```

**方式三：手动操作**

```bash
cd /data/www/pxcore
docker compose down
docker compose up -d --build
```

### 7.5 停止网站

```bash
cd /data/www/pxcore
docker compose down
```

### 7.6 查看资源使用

```bash
# 查看 Docker 容器占用
docker stats

# 查看磁盘空间
df -h
```

---

## 8. 常见问题

### Q1：部署时提示 "Docker not found"

**解决方法：**
```bash
# 检查 Docker 是否安装
docker --version

# 如果没安装，见 4.1 节安装 Docker
```

### Q2：证书申请失败

**常见原因：**
1. 域名未解析到服务器 IP
2. 服务器 80 端口未开放
3. 防火墙阻止

**排查方法：**
```bash
# 测试域名解析
nslookup www.pxcore.com.cn

# 测试端口连通性
telnet www.pxcore.com.cn 80
```

### Q3：网站打不开

**排查步骤：**
```bash
# 1. 检查容器是否运行
docker compose ps

# 2. 查看错误日志
docker compose logs -f

# 3. 检查 Nginx 配置
docker compose exec web nginx -t
```

### Q4：HTTPS 不生效

**解决方法：**
```bash
# 1. 确认证书已申请
ls -la certbot/conf/live/www.pxcore.com.cn/

# 2. 重启服务
docker compose up -d --build

# 3. 强制刷新浏览器缓存（Ctrl+Shift+R）
```

### Q5：忘记服务器密码

**解决方法：**
- 登录云服务器控制台（阿里云/腾讯云等）
- 找到"远程登录"或"VNC 登录"
- 使用控制台提供的"重置密码"功能

### Q6：如何修改网站内容

**步骤：**

1. **本地修改代码**
   ```bash
   cd d:\cursor-project\Website\site
   # 修改 src/pages/index.astro 等文件
   ```

2. **提交并推送到 GitHub**
   ```bash
   git add .
   git commit -m "feat: 修改说明"
   git push
   ```

3. **服务器拉取更新**
   ```bash
   cd /data/www/pxcore
   git pull
   ./deploy.sh
   ```

### Q7：域名需要备案吗

**答案：**
- 如果服务器在中国大陆，需要备案
- 如果服务器在港澳台或海外，不需要备案
- 具体请咨询你的云服务商

---

## 快速参考卡片

| 操作 | 命令 |
|------|------|
| 部署 | `./deploy.sh` |
| 重启 | `docker compose restart` |
| 停止 | `docker compose down` |
| 查看状态 | `docker compose ps` |
| 查看日志 | `docker compose logs -f` |
| 更新 | `./deploy.sh` |
| 续期证书 | `docker compose run --rm certbot renew --quiet` |
| 测试续期 | `docker compose run --rm certbot renew --dry-run` |

---

## 技术支持

遇到问题可以：
1. 查看日志：`docker compose logs -f`
2. 检查配置：`docker compose exec web nginx -t`
3. 搜索引擎搜索错误信息
4. 截图错误信息寻求帮助

---

**祝你部署顺利！**
