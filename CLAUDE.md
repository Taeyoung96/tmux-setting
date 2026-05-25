# tmux-config

이 repo는 tmux 설정 dotfiles입니다. 새 Ubuntu 머신에 tmux 환경을 그대로 복원합니다.

## 파일 구조

```
.tmux.conf                      # tmux 메인 설정
scripts/git-status.sh           # status bar용 git 브랜치/ahead/behind 표시 스크립트
scripts/hooks/post-merge        # git post-merge hook: tmux 설정 자동 동기화
install.sh                      # 원커맨드 설치 스크립트
```

## 새 머신에 설치하는 방법

```bash
bash install.sh
```

이 스크립트가 자동으로 처리하는 것:
1. tmux, xclip, git 설치 (없는 경우)
2. JetBrainsMono Nerd Font 설치 (아이콘 깨짐 방지)
3. Terminator 폰트 자동 설정 (`~/.config/terminator/config`)
4. `~/.tmux.conf` 복사
5. `~/.config/tmux/git-status.sh` 설치 및 실행 권한 부여
6. TPM(Tmux Plugin Manager) 설치
7. git post-merge hook 설치 (`scripts/hooks/post-merge` → `.git/hooks/post-merge`)
8. catppuccin, tmux-cpu, tmux-resurrect, tmux-continuum, tmux-agent-pulse 플러그인 자동 설치
   - tmux-agent-pulse: Claude Code / Codex / Hermes 응답 상태를 window 이름 아이콘으로 표시

## 주요 단축키

| 키 | 동작 |
|---|---|
| `Ctrl+Space` | Prefix |
| `Alt+Shift+방향키` | Pane 이동 |
| `Prefix + n/p` | 다음/이전 Window |
| `Prefix + L` | 이전 Window로 복귀 |
| `Prefix + r` | 설정 리로드 |
| `Prefix + Tab` | yazi 파일 탐색기 (50% 분할) |
| `Prefix + %` | 수평 분할 |
| `Prefix + "` | 수직 분할 |

## 단축키 충돌 주의사항

`Alt+Shift+방향키`를 tmux pane 이동에 사용합니다. 새 머신에 설치 시 아래 항목과 충돌 여부를 확인하세요:

| 확인 대상 | 확인 방법 |
|---|---|
| GNOME | Settings > Keyboard Shortcuts에서 Alt+Shift+방향키 검색 |
| Terminator | Preferences > Keybindings에서 확인 |
| 기타 터미널 | 해당 터미널의 keybinding 설정 확인 |

> 참고: Ubuntu + GNOME + Terminator 조합에서 충돌 없음 확인됨.
> - `Alt+방향키` → Terminator pane 이동
> - `Alt+Shift+방향키` → tmux pane 이동
> - `Ctrl+Alt+방향키` → GNOME workspace 이동

## Status Bar

오른쪽부터: `현재 디렉토리 | git브랜치 ↑ahead ↓behind | CPU% | RAM% | 날짜시간`

git 정보는 5분마다 자동 fetch하여 remote와의 차이를 표시합니다.

## tmux-agent-pulse

AI CLI 응답 상태를 tmux window 이름 아이콘으로 실시간 표시합니다.

| 아이콘 | 상태 |
|--------|------|
| `💬` | responding — AI가 응답 생성 중 |
| `✅` | done — 응답 완료, 확인 대기 |
| `❓` | waiting — 사용자 확인(permission) 필요 |

**지원 CLI:** Claude Code / Codex / Hermes

- 감지 방식: pane 자식 프로세스 확인 + 화면 스냅샷 해시 비교
- 플러그인 경로: `~/.tmux/plugins/tmux-agent-pulse/`
- 소스: https://github.com/Taeyoung96/tmux-agent-pulse

## Claude에게 설치 요청하는 방법

```
이 repo의 tmux 설정을 내 Ubuntu 머신에 설치해줘.
repo 경로: ~/tmux-config (이미 clone됨)
bash install.sh 실행하고 완료 확인해줘.
```
