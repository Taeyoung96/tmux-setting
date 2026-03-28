# tmux-config

이 repo는 tmux 설정 dotfiles입니다. 새 Ubuntu 머신에 tmux 환경을 그대로 복원합니다.

## 파일 구조

```
.tmux.conf              # tmux 메인 설정
scripts/git-status.sh   # status bar용 git 브랜치/ahead/behind 표시 스크립트
install.sh              # 원커맨드 설치 스크립트
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
7. catppuccin, tmux-cpu, tmux-resurrect, tmux-continuum, tmux-agent-pulse 플러그인 자동 설치

## 주요 단축키

| 키 | 동작 |
|---|---|
| `Ctrl+Space` | Prefix |
| `Ctrl+Shift+방향키` | Pane 이동 |
| `Prefix + n/p` | 다음/이전 Window |
| `Prefix + L` | 이전 Window로 복귀 |
| `Prefix + r` | 설정 리로드 |
| `Prefix + Tab` | yazi 파일 탐색기 (50% 분할) |
| `Prefix + %` | 수평 분할 |
| `Prefix + "` | 수직 분할 |

## Status Bar

오른쪽부터: `현재 디렉토리 | git브랜치 ↑ahead ↓behind | CPU% | RAM% | 날짜시간`

git 정보는 5분마다 자동 fetch하여 remote와의 차이를 표시합니다.

## Claude에게 설치 요청하는 방법

```
이 repo의 tmux 설정을 내 Ubuntu 머신에 설치해줘.
repo 경로: ~/tmux-config (이미 clone됨)
bash install.sh 실행하고 완료 확인해줘.
```
