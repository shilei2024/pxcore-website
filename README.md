<<<<<<< HEAD
# 鹏芯元创官网

本项目为静态落地页，基于 Astro + Tailwind CSS 构建，适合一键部署到自有云服务器。

## 开发与构建

使用国内镜像安装依赖（已在 `.npmrc` 配置）：

```sh
npm install
```

本地开发：

```sh
npm run dev
```

构建静态产物：

```sh
npm run build
```

## Docker 一键部署（自有云服务器）

服务器需要安装 Docker 和 Docker Compose。

```sh
chmod +x deploy.sh
./deploy.sh
```

默认会在 80 端口启动 Nginx 服务，静态产物位于容器内 `/usr/share/nginx/html`。

## 域名配置

将域名 `www.pxcore.com.cn` 解析到服务器公网 IP 后即可访问。

## HTTPS 配置（Certbot）

首次申请证书（请把邮箱替换成你的）：

```sh
docker compose run --rm certbot certonly \
  --webroot -w /var/www/certbot \
  -d www.pxcore.com.cn -d pxcore.com.cn \
  --email you@example.com --agree-tos --no-eff-email
```

申请完成后重启服务：

```sh
docker compose up -d --build
```

证书自动续期（建议添加到 crontab，每天一次）：

```sh
docker compose run --rm certbot renew
```
=======
# pxcore-website
a website
>>>>>>> ef1d0f0ff0aa69ebf930c2fa9be4747234678e1c
