#!/usr/bin/env sh
set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 开始部署鹏芯元创官网${NC}"
echo "================================"

# 检查是否在正确的目录
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ 错误：未找到 package.json，请确保在项目根目录执行此脚本${NC}"
    exit 1
fi

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null && [ ! -x "/usr/bin/docker" ]; then
    echo -e "${RED}❌ 错误：Docker 未安装，请先安装 Docker${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker 已安装${NC}"

# 检查 Docker Compose
if ! docker compose version &> /dev/null && [ ! -x "/usr/bin/docker-compose" ]; then
    echo -e "${RED}❌ 错误：Docker Compose 未安装${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker Compose 已安装${NC}"

echo ""
echo -e "${YELLOW}📦 步骤 1/4：安装依赖...${NC}"
npm install

echo ""
echo -e "${YELLOW}🔨 步骤 2/4：构建项目...${NC}"
npm run build

echo ""
echo -e "${YELLOW}🐳 步骤 3/4：停止旧容器...${NC}"
docker compose down || true

echo ""
echo -e "${YELLOW}🚀 步骤 4/4：启动新容器...${NC}"
docker compose up -d --build

echo ""
echo "================================"
echo -e "${GREEN}✅ 部署完成！${NC}"
echo ""
echo -e "访问地址：${YELLOW}http://www.pxcore.com.cn${NC}"
echo ""
echo -e "查看日志：${YELLOW}docker compose logs -f${NC}"
echo -e "停止服务：${YELLOW}docker compose down${NC}"
