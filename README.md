# tmux-config

Ubuntu 환경을 위한 tmux dotfiles. 새 머신에서 `bash install.sh` 한 번으로 전체 환경을 복원합니다.

## 미리보기

**Status Bar**: `[세션] ... [디렉토리] [ main ↑2↓1] [ 12%] [ 34%] [ 03/26 14:30]`

- git 브랜치 + remote 대비 ahead/behind 자동 표시
- Catppuccin Mocha 테마
- Active pane: 흰색 굵은 테두리로 강조

## 빠른 시작

```bash
git clone https://github.com/YOUR_USERNAME/tmux-config.git ~/tmux-config
cd ~/tmux-config
bash install.sh
```

설치 후 터미널을 재시작하거나:
```bash
tmux source ~/.tmux.conf
```

## 요구 사항

- Ubuntu 20.04+ / Debian 11+
- `git` (설치 스크립트가 `tmux`, `xclip`은 자동 설치)
- (선택) `yazi` — Prefix+Tab 파일 탐색기 사용 시

## 파일 구조

```
tmux-config/
├── .tmux.conf              # tmux 메인 설정
├── scripts/
│   └── git-status.sh       # git 브랜치/ahead/behind 스크립트
├── install.sh              # 원커맨드 설치 스크립트
├── CLAUDE.md               # Claude Code 자동 로드용
├── prompt.md               # Claude.ai 웹용 프롬프트
└── README.md
```

## install.sh가 하는 일

| 단계 | 내용 |
|------|------|
| 1 | tmux, xclip, git 설치 (없는 경우) |
| 2 | JetBrainsMono Nerd Font 설치 |
| 3 | Terminator 폰트 설정 |
| 4 | `~/.tmux.conf` 복사 |
| 5 | `~/.config/tmux/git-status.sh` 설치 |
| 6 | TPM(Tmux Plugin Manager) 설치 |
| 7 | git post-merge hook 설치 (git pull 시 tmux 설정 자동 동기화) |
| 8 | TPM 플러그인 자동 설치 (catppuccin, tmux-cpu, resurrect, continuum) |

## 단축키

### Prefix
`Ctrl+Space`

### Pane

| 키 | 동작 |
|---|---|
| `Ctrl+Shift+←↑↓→` | Pane 이동 |
| `Prefix + %` | 수평 분할 |
| `Prefix + "` | 수직 분할 |
| `Prefix + Tab` | yazi 파일 탐색기 (50% 분할) |

### Window

| 키 | 동작 |
|---|---|
| `Prefix + n` | 다음 Window |
| `Prefix + p` | 이전 Window |
| `Prefix + 0~9` | 번호로 이동 |
| `Prefix + L` | 이전 Window로 복귀 |

### 기타

| 키 | 동작 |
|---|---|
| `Prefix + r` | 설정 리로드 |
| Copy mode | `v` 선택, `y` 복사 (클립보드) |

## Claude와 함께 사용하기

### Claude Code (권장)

이 repo 디렉토리를 열면 `CLAUDE.md`가 자동으로 로드됩니다.

```bash
cd ~/tmux-config
claude  # Claude Code 실행 → CLAUDE.md 자동 인식
```

그 다음 Claude에게:
```
이 머신에 tmux 설정 설치해줘
```

### Claude.ai 웹

`prompt.md` 파일의 내용을 복사해서 Claude에게 붙여넣으세요.

```bash
cat ~/tmux-config/prompt.md
```

## git pull 자동 동기화

`bash install.sh` 실행 후, `git pull` 시 tmux 설정이 자동으로 동기화됩니다.

`.git/hooks/post-merge` hook이 설치되어 있어 pull로 파일이 변경되면:

- `.tmux.conf` → `~/.tmux.conf` 자동 복사
- `scripts/git-status.sh` → `~/.config/tmux/git-status.sh` 자동 복사

변경이 있으면 터미널에 아래 메시지가 출력됩니다:
```
[tmux-sync] .tmux.conf 업데이트 완료
[tmux-sync] git-status.sh 변경 없음
[tmux-sync] tmux 설정 리로드 완료
```

변경이 없으면:
```
[tmux-sync] .tmux.conf 변경 없음
[tmux-sync] git-status.sh 변경 없음
```

## 설정 변경 후 동기화

repo에 변경사항을 push하면 다른 머신에서 `git pull` 시 자동으로 동기화됩니다.

```bash
# 현재 설정을 repo에 반영
cp ~/.tmux.conf ~/tmux-config/.tmux.conf
cp ~/.config/tmux/git-status.sh ~/tmux-config/scripts/git-status.sh

cd ~/tmux-config
git add -A && git commit -m "chore: update tmux config"
git push
```

다른 머신에서 `git pull`하면 자동으로 동기화됩니다.

## 플러그인 목록

| 플러그인 | 역할 |
|---------|------|
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Mocha 테마 |
| [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) | CPU/RAM 표시 |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | 세션 저장/복원 |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | 자동 세션 저장 |
