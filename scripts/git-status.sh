#!/bin/bash
# tmux git status with auto-fetch (rate-limited to every 5 minutes)
# Shows: branch-name ↑ahead ↓behind

cd "$1" 2>/dev/null || exit

b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$b" ] && exit

# 5분마다 백그라운드 fetch (repo별 타임스탬프)
root=$(git rev-parse --show-toplevel 2>/dev/null)
stamp="/tmp/.tmux_gitfetch_$(echo "$root" | md5sum | head -c8)"
now=$(date +%s)
last=$(cat "$stamp" 2>/dev/null || echo 0)
if [ $((now - last)) -gt 300 ]; then
    git fetch -q --all 2>/dev/null &
    echo "$now" > "$stamp"
fi

# ahead / behind 계산
a=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
d=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

s=""
[ -n "$a" ] && [ "$a" != "0" ] && s=" ↑$a"
[ -n "$d" ] && [ "$d" != "0" ] && s="$s ↓$d"

echo "#[bg=default] #[fg=#a6e3a1,bg=#313244]  $b$s "
