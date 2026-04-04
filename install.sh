#!/bin/bash
set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[1/8] 의존성 확인 및 설치...${NC}"
if ! command -v tmux &>/dev/null; then
    echo "  tmux가 없습니다. 설치 중..."
    sudo apt-get update -qq && sudo apt-get install -y tmux
    echo "  tmux 설치 완료: $(tmux -V)"
else
    echo "  tmux 이미 설치됨: $(tmux -V)"
fi
if ! command -v xclip &>/dev/null; then
    echo "  xclip 설치 중..."
    sudo apt-get install -y xclip
fi
if ! command -v git &>/dev/null; then
    echo "  git 설치 중..."
    sudo apt-get install -y git
fi

echo -e "${GREEN}[2/8] Nerd Font 설치...${NC}"
if fc-list | grep -qi "JetBrainsMono.*Nerd"; then
    echo "  JetBrainsMono Nerd Font 이미 설치됨, 스킵"
else
    echo "  JetBrainsMono Nerd Font 설치 중..."
    mkdir -p ~/.local/share/fonts
    curl -fLo /tmp/JetBrainsMono.tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    tar -xf /tmp/JetBrainsMono.tar.xz -C ~/.local/share/fonts
    fc-cache -fv >/dev/null 2>&1
    rm -f /tmp/JetBrainsMono.tar.xz
    echo "  Nerd Font 설치 완료"
fi

echo -e "${GREEN}[3/8] Terminator 폰트 설정...${NC}"
TERM_CONFIG="$HOME/.config/terminator/config"
if [ -f "$TERM_CONFIG" ]; then
    if grep -q "font = JetBrainsMono Nerd Font" "$TERM_CONFIG"; then
        echo "  Terminator 폰트 이미 설정됨, 스킵"
    else
        # [[default]] 프로필에 폰트 설정 추가
        sed -i '/\[profiles\]/,/\[\[default\]\]/{/\[\[default\]\]/a\    font = JetBrainsMono Nerd Font 12\n    use_system_font = False
}' "$TERM_CONFIG"
        echo "  Terminator 폰트 설정 완료"
    fi
else
    echo "  Terminator 설정 파일 생성 중..."
    mkdir -p "$(dirname "$TERM_CONFIG")"
    cat > "$TERM_CONFIG" <<'TERMCFG'
[global_config]
[keybindings]
[profiles]
  [[default]]
    font = JetBrainsMono Nerd Font 12
    use_system_font = False
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
TERMCFG
    echo "  Terminator 설정 파일 생성 완료"
fi

echo -e "${GREEN}[4/8] tmux.conf 복사...${NC}"
cp "$REPO_DIR/.tmux.conf" ~/.tmux.conf

echo -e "${GREEN}[5/8] git-status.sh 설치...${NC}"
mkdir -p ~/.config/tmux
cp "$REPO_DIR/scripts/git-status.sh" ~/.config/tmux/git-status.sh
chmod +x ~/.config/tmux/git-status.sh

echo -e "${GREEN}[6/8] TPM (Tmux Plugin Manager) 설치...${NC}"
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "  TPM 이미 설치됨, 스킵"
fi

echo -e "${GREEN}[7/8] git hook 설치...${NC}"
HOOK_SRC="$REPO_DIR/scripts/hooks/post-merge"
HOOK_DST="$REPO_DIR/.git/hooks/post-merge"
if [ -f "$HOOK_DST" ] && diff -q "$HOOK_SRC" "$HOOK_DST" &>/dev/null; then
    echo "  git hook 이미 설치됨, 스킵"
else
    cp "$HOOK_SRC" "$HOOK_DST"
    chmod +x "$HOOK_DST"
    echo "  git hook 설치 완료"
fi

echo -e "${GREEN}[8/8] TPM 플러그인 자동 설치...${NC}"
# 기존 임시 세션 정리
tmux kill-session -t _install 2>/dev/null || true

# 새 headless 세션 생성 후 conf 로드 및 플러그인 설치
tmux new-session -d -s _install
tmux source ~/.tmux.conf 2>/dev/null || true
~/.tmux/plugins/tpm/bin/install_plugins
tmux kill-session -t _install 2>/dev/null || true

echo -e "\n${GREEN}설치 완료!${NC}"
echo -e "${YELLOW}새 터미널에서 tmux를 실행하거나, 이미 tmux 안에 있다면 'Prefix+r' 로 설정을 리로드하세요.${NC}"
echo -e "${YELLOW}이제부터 git pull 시 tmux 설정이 자동으로 동기화됩니다.${NC}"
echo ""
echo "단축키 요약:"
echo "  Prefix       : Ctrl+Space"
echo "  Pane 이동    : Ctrl+Shift+방향키"
echo "  Window 이동  : Prefix+n/p, Prefix+L (이전)"
echo "  설정 리로드  : Prefix+r"
echo "  yazi         : Prefix+Tab"
echo ""
echo "설치된 항목:"
echo "  - git hook: .git/hooks/post-merge (tmux 설정 자동 동기화)"
echo ""
echo "설치된 플러그인:"
echo "  - catppuccin/tmux         (테마)"
echo "  - tmux-plugins/tmux-cpu   (CPU/RAM 표시)"
echo "  - tmux-plugins/tmux-resurrect  (세션 복원)"
echo "  - tmux-plugins/tmux-continuum  (자동 저장)"
echo "  - Taeyoung96/tmux-agent-pulse  (AI CLI 상태 표시)"
