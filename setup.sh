#!/usr/bin/env bash
# tmux_config setup —— 在新机器上:clone 本仓库后运行本脚本即可。
# 做三件事:① 软链 ~/.tmux.conf -> 本仓库的 tmux.conf ② 安装插件
# ③ 给 tmux-256color 补 SGR 鼠标(1006)能力(见下文)。
# 幂等:可重复运行。
set -euo pipefail

# 本仓库所在目录(无论 clone 到哪里都能正确定位)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$REPO_DIR/tmux.conf"
PLUGINS_DIR="$HOME/.tmux/plugins"
LINK="$HOME/.tmux.conf"

say() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*"; }

# 0) 检查 tmux
if ! command -v tmux >/dev/null 2>&1; then
  warn "未找到 tmux,请先安装(滚动条需要 >= 3.5,推荐 3.6+)。"; exit 1
fi
ver="$(tmux -V | awk '{print $2}')"
say "tmux 版本: $ver"
case "$ver" in
  1.*|2.*|3.0*|3.1*|3.2*|3.3*|3.4*) warn "版本偏低,pane 滚动条需要 3.5+;其余功能仍可用。" ;;
esac

# 1) 软链 ~/.tmux.conf -> 仓库 tmux.conf
if [ -L "$LINK" ]; then
  rm -f "$LINK"
elif [ -e "$LINK" ]; then
  warn "已存在真实文件 $LINK,备份为 $LINK.bak"
  mv "$LINK" "$LINK.bak"
fi
ln -s "$CONF" "$LINK"
say "软链: $LINK -> $CONF"

# 2) 安装插件(直接 clone,pin 版本,自动拉子模块)
mkdir -p "$PLUGINS_DIR"
clone_plugin() {  # url  dir  [ref]
  url="$1"; dir="$2"; ref="${3:-}"
  if [ -d "$dir/.git" ]; then say "已存在,跳过: $(basename "$dir")"; return; fi
  say "克隆: $url ${ref:+($ref)}"
  if [ -n "$ref" ]; then
    git clone --depth 1 --branch "$ref" --recurse-submodules "$url" "$dir"
  else
    git clone --depth 1 --recurse-submodules "$url" "$dir"
  fi
}
clone_plugin https://github.com/tmux-plugins/tpm            "$PLUGINS_DIR/tpm"
clone_plugin https://github.com/catppuccin/tmux             "$PLUGINS_DIR/tmux"            v2.3.0
clone_plugin https://github.com/alexwforsythe/tmux-which-key "$PLUGINS_DIR/tmux-which-key"
clone_plugin https://github.com/omerxx/tmux-floax            "$PLUGINS_DIR/tmux-floax"

# which-key 的 PyYAML 是子模块;上面 --recurse-submodules 已处理,这里兜底确认
WK="$PLUGINS_DIR/tmux-which-key"
if [ -f "$WK/.gitmodules" ] && [ ! -e "$WK/plugin/pyyaml/lib/yaml/__init__.py" ]; then
  say "补拉 which-key 子模块 (pyyaml)"
  git -C "$WK" submodule update --init --recursive
fi

# 3) 给 tmux-256color 补 SGR 鼠标 (1006) 能力
#    系统 tmux-256color 没有完整的 SGR 鼠标能力,导致 vim/less/htop 等用 terminfo 启用鼠标
#    的程序回退到老式 1000 编码:在宽窗口里点击坐标 > 95 时字节 > 127,被 UTF-8
#    拆成多字节,3 字节鼠标协议散架,残余字节漏到 shell 被回显成一串乱码
#    (Windows Terminal 下尤其常见)。补上 kmous/XM/xm 后程序改用全 ASCII 的 SGR(1006)
#    编码,问题消失。幂等:已具备完整 SGR 鼠标能力则跳过。
if command -v infocmp >/dev/null 2>&1; then
  current_ti="$(infocmp -x -1 tmux-256color 2>/dev/null || true)"
  if printf '%s\n' "$current_ti" | grep -q 'kmous=\\E\[<,' &&
     printf '%s\n' "$current_ti" | grep -q 'XM=' &&
     printf '%s\n' "$current_ti" | grep -q 'xm='; then
    say "tmux-256color 已具备完整 SGR 鼠标 (1006),跳过"
  else
    say "为 tmux-256color 注入 SGR 鼠标 (1006) 能力 -> ~/.terminfo"
    tmp_terminfo="$(mktemp)"
    {
      infocmp -x tmux-256color 2>/dev/null
      cat <<'EOF'
	kmous=\E[<, XM=\E[?1006;1000%?%p1%{1}%=%th%el%;,
	xm=\E[<%i%p3%d;%p1%d;%p2%d;%?%p4%tM%em%;,
EOF
    } > "$tmp_terminfo"
    tic -x -o "$HOME/.terminfo" "$tmp_terminfo"
    rm -f "$tmp_terminfo"
  fi
fi

echo
say "完成 ✅  启动 tmux 即可;若已在 tmux 中,按 prefix(Ctrl+b)再按 r 重载。"
echo "    提示:终端字体需含 Nerd Font 图标(推荐 Maple Mono NF CN),"
echo "          否则状态栏的 session/时钟等图标会显示成方块。"
echo "    鼠标:新装的 terminfo 只对启动后新开的程序生效,已有的 vim/less 等"
echo "          需退出重开一次才会用上 SGR 鼠标。"
