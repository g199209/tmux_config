# tmux_config

我的个人 tmux 配置 —— 目标是「像 zellij 一样开箱顺手」:漂亮的状态栏、不用背键位、还原 zellij 的模式化操作。

## 特性

- **主题**:[catppuccin](https://github.com/catppuccin/tmux) **Mocha**,圆角药丸 tab 栏,放在**顶部**。
- **不用背键位**:[tmux-which-key](https://github.com/alexwforsythe/tmux-which-key),`prefix + Space` 弹出可下钻的动作菜单。
- **免 prefix 切 pane**:`Alt + h/j/k/l`(或 `Alt + 方向键`),照搬 zellij。
- **zellij 式模式**:`Ctrl+p` 进 PANE 模式、`Ctrl+w` 进 TAB(window)模式,进入后单键连续操作(动作键做完自动退,移动键留在模式里),`Esc` 退出,顶栏显示当前模式 + 可用键。
- **浮动终端**:[tmux-floax](https://github.com/omerxx/tmux-floax),`Alt+f` 开/关浮动终端,内容常驻(对齐 zellij 的 Alt+f)。
- **滚动条**:`modal` —— 仅滚动时在右侧出现,平时不占视觉(需 tmux ≥ 3.5)。
- 鼠标、vi 复制键位、50k 回滚、真彩色等常用项已配好。

## 依赖

- **tmux ≥ 3.5**(滚动条需要;推荐 3.6+)。本机的 tmux 是从源码编译装在 `~/.local/bin`。
- **含 Nerd Font 图标的等宽字体**,装在**跑终端的那台机器**上(SSH 的话是本地 Mac/Windows,不是服务器)。
  推荐 **[Maple Mono NF CN](https://github.com/subframe7536/maple-font/releases)**(Nerd 图标 + 中文 + 等宽),装好后在终端里把字体选成 `Maple Mono NF CN`。
  字体不对的话,状态栏的 session/时钟等图标会显示成方块/问号。
- `git`(setup 脚本用它装插件)。

## 安装(新机器)

```sh
git clone git@github.com:g199209/tmux_config.git ~/.config/tmux
~/.config/tmux/setup.sh
tmux
```

`setup.sh` 会:
1. 软链 `~/.tmux.conf` → 本仓库的 `tmux.conf`(已有真实文件则备份为 `~/.tmux.conf.bak`);
2. 把插件 clone 到 `~/.tmux/plugins/`(TPM、catppuccin@v2.3.0、which-key,自动拉 which-key 的 PyYAML 子模块)。

> clone 到别的目录也行,`setup.sh` 会自动定位自身位置;`~/.config/tmux` 只是推荐。
> 脚本幂等,可重复运行。

## 常用键位

`prefix` = `Ctrl+b`。**忘了任何操作 → `prefix` 然后 `Space`,看菜单。**

| 操作 | 键 |
| --- | --- |
| which-key 菜单 | `prefix` `Space` |
| 切 pane(免 prefix) | `Alt+h/j/k/l` 或 `Alt+方向` |
| 新建 pane | `Alt+n` |
| 浮动终端 开/关 | `Alt+f`(内容常驻) |
| 左右 / 上下 分屏 | `prefix` `\|` / `-` |
| 新建窗口(≈ tab) | `prefix` `c` |
| 放大/还原 pane | `prefix` `z` |
| PANE 模式(免 prefix) | `Ctrl+p` → `hjkl` 移动 / `n s x z`(做完即退)/ `Esc` 退 |
| TAB 模式(免 prefix) | `Ctrl+w`(w=window) → `h l` 切换 / `n x r`(做完即退)/ `Esc` 退 |
| 重载配置 | `prefix` `r` |
| 脱离 / 重连 | `prefix` `d` / `tmux a` |

鼠标全程可用:点选 pane、拖边框调大小、滚轮翻历史(滚动时右侧才出现滚动条)。

## 更新

```sh
cd ~/.config/tmux && git pull
# 配置改动:在 tmux 里 prefix + r 重载即可
# 想更新插件版本:改 tmux.conf 里的 @plugin / setup.sh 里的 pin,再重跑 setup.sh
```

## 本机特定配置

想加只在某台机器生效的设置:新建 `~/.config/tmux/local.conf`(被 `.gitignore` 忽略),
并在 `tmux.conf` 末尾加 `source -q ~/.config/tmux/local.conf`。
