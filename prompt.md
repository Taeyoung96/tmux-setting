# tmux 설정 설치 프롬프트

> Claude.ai 웹 또는 Claude Code에 아래 내용을 그대로 붙여넣어 사용하세요.

---

## 사용법

1. 새 머신에서 이 repo를 clone합니다:
   ```bash
   git clone https://github.com/YOUR_USERNAME/tmux-config.git ~/tmux-config
   ```

2. 아래 프롬프트를 Claude에게 전달합니다.

---

## Claude에게 전달할 프롬프트

```
내 tmux dotfiles repo를 이 Ubuntu 머신에 설치해줘.

repo 위치: ~/tmux-config

설치 절차:
1. `bash ~/tmux-config/install.sh` 실행
2. 설치 중 에러가 있으면 해결
3. Nerd Font 설치 (아이콘 깨짐 방지):
   - `mkdir -p ~/.local/share/fonts`
   - `curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz`
   - `tar -xf JetBrainsMono.tar.xz -C ~/.local/share/fonts && fc-cache -fv`
4. Terminator 사용 시 폰트 자동 설정:
   - `~/.config/terminator/config` 파일의 `[profiles]` → `[[default]]` 섹션에 아래 추가:
     `font = JetBrainsMono Nerd Font 12`
     `use_system_font = False`
   - 파일이 없으면 `mkdir -p ~/.config/terminator` 후 생성
5. tmux를 재시작하거나 `tmux source ~/.tmux.conf` 실행
6. 정상 동작 확인 (tmux 실행 후 status bar에 git 브랜치, CPU/RAM 아이콘이 깨지지 않으면 성공)

설치 후 확인 사항:
- `~/.tmux.conf` 존재 여부
- `~/.config/tmux/git-status.sh` 존재 및 실행 권한
- `~/.tmux/plugins/tpm` 존재 여부
- tmux 실행 시 catppuccin 테마 적용 여부
- Nerd Font 설치 여부: `fc-list | grep -i "JetBrains.*Nerd"`
- Terminator 폰트 설정 여부: `~/.config/terminator/config`에 font 설정 확인
```

---

## 주요 단축키 (설치 후 참고)

| 키 | 동작 |
|---|---|
| `Ctrl+Space` | Prefix |
| `Ctrl+Shift+방향키` | Pane 이동 |
| `Prefix + n/p` | 다음/이전 Window |
| `Prefix + L` | 이전 Window |
| `Prefix + r` | 설정 리로드 |
| `Prefix + Tab` | yazi 파일 탐색기 |

## Status Bar 구성

```
[세션명] ... [현재디렉토리] [git브랜치 ↑2↓1] [CPU%] [RAM%] [날짜 시간]
```

- `↑N` : remote보다 N 커밋 앞
- `↓N` : remote보다 N 커밋 뒤
- git 정보는 5분마다 자동 fetch
