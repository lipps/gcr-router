#!/bin/bash
# GCR Router - GitHub 部署脚本
# 自动将项目推送到 GitHub

set -e

echo "🚀 GCR Router - GitHub 部署"
echo "================================"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查git是否安装
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git 未安装。请先安装 Git。${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Git 已安装${NC}"

# 获取GitHub用户名
GITHUB_USERNAME="lipps"
REPO_NAME="gcr-router"

echo ""
echo -e "${BLUE}📝 项目信息:${NC}"
echo "   GitHub 用户: $GITHUB_USERNAME"
echo "   仓库名称: $REPO_NAME"
echo "   远程URL: https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo ""

# 确认继续
read -p "是否继续部署到 GitHub? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "部署已取消"
    exit 0
fi

# 进入项目目录
cd "$(dirname "$0")"

# 初始化 Git 仓库
if [ ! -d ".git" ]; then
    echo -e "${BLUE}📦 初始化 Git 仓库...${NC}"
    git init
    echo -e "${GREEN}✓ Git 仓库已初始化${NC}"
else
    echo -e "${GREEN}✓ Git 仓库已存在${NC}"
fi

# 创建 .gitignore（如果还没有完整的）
echo -e "${BLUE}📝 确保 .gitignore 配置正确...${NC}"

# 添加所有文件
echo -e "${BLUE}📦 添加项目文件...${NC}"
git add .
echo -e "${GREEN}✓ 文件已添加${NC}"

# 提交
echo -e "${BLUE}💾 创建初始提交...${NC}"
git commit -m "Initial commit: GCR Router v1.0.0

🚀 Features:
- Intelligent task analysis and model routing
- Support for GPT-4, Claude, and other models
- Multiple routing strategies (balanced, cost-optimized, quality-first, speed-first)
- VS Code extension integration
- Real-time cost tracking
- Docker support
- Comprehensive documentation

📦 Components:
- FastAPI backend
- Task analyzer with pattern matching
- Routing engine with 4 strategies
- Model adapter for OpenAI, Anthropic, OpenRouter
- VS Code extension with inline completions
- Test suite and examples

📚 Documentation:
- README.md - Complete documentation
- QUICKSTART.md - 5-minute setup guide
- PROJECT_DELIVERY.md - Project overview
- API docs at /docs endpoint

🎯 Ready to use:
1. Configure API keys in backend/.env
2. Run ./start.sh
3. Test with python test_client.py
" || echo -e "${YELLOW}⚠️  没有新的更改需要提交${NC}"

# 设置主分支名称为 main
echo -e "${BLUE}🌿 设置主分支为 main...${NC}"
git branch -M main
echo -e "${GREEN}✓ 分支已设置${NC}"

# 添加远程仓库
REMOTE_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
echo -e "${BLUE}🔗 配置远程仓库...${NC}"

if git remote | grep -q "^origin$"; then
    echo -e "${YELLOW}⚠️  远程仓库 'origin' 已存在，更新URL...${NC}"
    git remote set-url origin "$REMOTE_URL"
else
    git remote add origin "$REMOTE_URL"
fi
echo -e "${GREEN}✓ 远程仓库已配置: $REMOTE_URL${NC}"

echo ""
echo -e "${YELLOW}⚠️  准备推送到 GitHub${NC}"
echo ""
echo -e "${BLUE}📋 下一步操作:${NC}"
echo ""
echo -e "${GREEN}选项 1: 使用 HTTPS (推荐)${NC}"
echo "   1. 确保你已在 GitHub 上创建了 $REPO_NAME 仓库"
echo "   2. 运行: git push -u origin main"
echo "   3. 输入你的 GitHub 用户名和 Personal Access Token"
echo ""
echo -e "${GREEN}选项 2: 使用 SSH${NC}"
echo "   1. 配置 SSH 密钥: ssh-keygen -t ed25519 -C 'your_email@example.com'"
echo "   2. 添加到 GitHub: cat ~/.ssh/id_ed25519.pub"
echo "   3. 更改远程URL: git remote set-url origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
echo "   4. 推送: git push -u origin main"
echo ""
echo -e "${BLUE}💡 获取 Personal Access Token:${NC}"
echo "   1. 访问: https://github.com/settings/tokens"
echo "   2. Generate new token (classic)"
echo "   3. 勾选 'repo' 权限"
echo "   4. 生成并复制 token"
echo ""
echo -e "${YELLOW}⚠️  Token 只显示一次，请妥善保存！${NC}"
echo ""

# 询问是否立即推送
read -p "是否现在推送? 确保仓库已在 GitHub 创建 (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${BLUE}🚀 推送到 GitHub...${NC}"
    echo ""
    
    # 尝试推送
    if git push -u origin main; then
        echo ""
        echo -e "${GREEN}✅ 成功推送到 GitHub!${NC}"
        echo ""
        echo -e "${BLUE}🎉 项目地址:${NC}"
        echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME"
        echo ""
        echo -e "${BLUE}📚 下一步:${NC}"
        echo "   1. 在 GitHub 上查看你的项目"
        echo "   2. 添加项目描述和标签"
        echo "   3. 启用 GitHub Pages (可选)"
        echo "   4. 设置 Issues 和 Discussions"
        echo ""
    else
        echo ""
        echo -e "${RED}❌ 推送失败${NC}"
        echo ""
        echo -e "${YELLOW}可能的原因:${NC}"
        echo "   1. 仓库未在 GitHub 创建"
        echo "   2. 认证失败（用户名或token错误）"
        echo "   3. 权限不足"
        echo "   4. 网络问题"
        echo ""
        echo -e "${BLUE}手动推送:${NC}"
        echo "   git push -u origin main"
        echo ""
    fi
else
    echo ""
    echo -e "${BLUE}📋 手动推送步骤:${NC}"
    echo ""
    echo "1. 在 GitHub 创建仓库:"
    echo "   https://github.com/new"
    echo "   仓库名: $REPO_NAME"
    echo "   不要初始化 README, .gitignore 或 license"
    echo ""
    echo "2. 推送代码:"
    echo "   git push -u origin main"
    echo ""
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}✅ Git 配置完成!${NC}"
echo -e "${GREEN}================================${NC}"
