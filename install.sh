#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}[1/5] 의존성 확인 및 설치...${NC}"
if ! command -v tmux &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y tmux
fi
if ! command -v xclip &>/dev/null; then
    sudo apt-get install -y xclip
fi

echo -e "${GREEN}[2/5] tmux.conf 복사...${NC}"
cp "$REPO_DIR/.tmux.conf" ~/.tmux.conf

echo -e "${GREEN}[3/5] git-status.sh 설치...${NC}"
mkdir -p ~/.config/tmux
cp "$REPO_DIR/scripts/git-status.sh" ~/.config/tmux/git-status.sh
chmod +x ~/.config/tmux/git-status.sh

echo -e "${GREEN}[4/5] TPM (Tmux Plugin Manager) 설치...${NC}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "  TPM 이미 설치됨, 스킵"
fi

echo -e "${GREEN}[5/5] TPM 플러그인 자동 설치...${NC}"
# tmux 서버가 실행 중이 아니면 headless로 플러그인 설치
if tmux info &>/dev/null 2>&1; then
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
else
    tmux new-session -d -s _install 2>/dev/null || true
    tmux source ~/.tmux.conf
    ~/.tmux/plugins/tpm/bin/install_plugins
    tmux kill-session -t _install 2>/dev/null || true
fi

echo -e "\n${GREEN}설치 완료!${NC}"
echo -e "${YELLOW}tmux를 재시작하거나 'tmux source ~/.tmux.conf' 를 실행하세요.${NC}"
echo ""
echo "단축키 요약:"
echo "  Prefix      : Ctrl+Space"
echo "  Pane 이동   : Ctrl+Shift+방향키"
echo "  Window 이동 : Prefix+n/p, Prefix+L (이전)"
echo "  설정 리로드 : Prefix+r"
echo "  yazi        : Prefix+Tab"
