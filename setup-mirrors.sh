#!/bin/bash
# Docker 镜像加速器配置脚本
# 适用于中国大陆服务器

set -e

echo "🔧 配置 Docker 镜像加速器..."
echo ""

# 检查权限
if [ "$EUID" -ne 0 ]; then
    echo "❌ 请使用 root 权限运行: sudo $0"
    exit 1
fi

# 创建 Docker 配置目录
mkdir -p /etc/docker

# 创建 daemon.json 配置文件
cat > /etc/docker/daemon.json << 'EOF'
{
  "registry-mirrors": [
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com",
    "https://registry.docker-cn.com",
    "https://mirror.ccs.tencentyun.com"
  ]
}
EOF

echo "✅ 已创建 /etc/docker/daemon.json"
echo ""
echo "📄 配置内容:"
cat /etc/docker/daemon.json
echo ""
echo ""

# 重启 Docker 服务
echo "🔄 重启 Docker 服务..."
systemctl restart docker

echo ""
echo "✅ Docker 镜像加速器配置完成！"
echo ""
echo "📋 验证配置:"
docker info | grep -A 5 "Registry Mirrors"
echo ""
echo "⚠️  注意：配置已生效，但之前下载的镜像需要重新拉取"
echo "💡 提示：可以删除旧镜像后重新部署："
echo "   docker compose down"
echo "   docker system prune -a"
echo "   ./deploy.sh"
