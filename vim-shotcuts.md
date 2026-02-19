# Firefox + Neovim/LazyVim + i3wm  
## 1. Firefox – Tab Navigation

### Default Shortcuts (Windows/Linux)
- Next tab (right)          →  Ctrl + Tab    or    Ctrl + PageDown
- Previous tab (left)       →  Ctrl + Shift + Tab    or    Ctrl + PageUp
- Jump to tab by position   →  Ctrl + 1 … Ctrl + 8
- Last tab                  →  Ctrl + 9
- Move tab left/right       →  Ctrl + Shift + PageUp / PageDown

### macOS
- Next     →  Cmd + Option + →
- Previous →  Cmd + Option + ←

### Vim/i3-like with extensions (recommended)
Vimium C (lightweight & fast – preferred for most users)
- Shift + K                 → next tab
- Shift + J                 → previous tab
- h / j / k / l             → scroll page (normal mode)
- x                         → close tab
- g0 / g$                   → first / last tab

Tridactyl (full modal Vim experience)
- gt                        → next tab
- gT                        → previous tab
- Custom example:
  :bind J tabprev
  :bind K tabnext
- b / :buffer               → fuzzy tab search & jump

## 2. Neovim / LazyVim – Key Bindings by Mode

### Normal Mode – Alphabet + Common Shift/Ctrl

| Key / Combo         | Action / Description                                      | Notes / Common Usage                     |
|---------------------|-----------------------------------------------------------|------------------------------------------|
| a / A               | Append (after cursor / end of line)                       | Start insert mode                        |
| b / B               | Backward word / WORD                                      | Motion                                   |
| c / C               | Change (delete + insert) / to EOL                         | Operator: ciw, cc, C                     |
| d / D               | Delete / to EOL                                           | Operator: dw, dd, D                      |
| e / E               | End of word / WORD                                        | Motion                                   |
| f / F, t / T        | Find / Till char forward/backward                         | ; / , to repeat                          |
| g                   | Prefix: gg (top), gu/gU (case), gj/gk (display lines)     | guw → lowercase word                     |
| G                   | Go to last line (or N G)                                  | 10G → line 10                            |
| h j k l             | ← ↓ ↑ →                                                   | Core movement                            |
| H M L               | Top / Middle / Bottom of screen                           | Viewport jump                            |
| i / I               | Insert before cursor / at line start                      | Most common insert                       |
| J                   | Join line with next                                       | Remove newline                           |
| K                   | Keyword lookup (man/help)                                 | Often remapped                           |
| m / M               | Set mark (ma–mz local, mA–mZ global)                      | 'a → jump to line, `a → exact position   |
| n / N               | Next / previous search match                              | After / or ?                             |
| o / O               | Open line below/above + insert                            | New line                                 |
| p / P               | Paste after/before cursor                                 | After yank/delete                        |
| q                   | Record macro (qa … actions … q)                           | Powerful; often remapped                 |
| Q                   | Enter Ex mode (rare)                                      | Usually disabled                         |
| r / R               | Replace single char / enter Replace mode                  | rx, R → overtype                         |
| s / S               | Substitute char / whole line                              | Like cl / ^C                             |
| u / U               | Undo / undo line changes                                  | u / 5u                                   |
| v / V               | Character / line-wise Visual                              | Selection modes                          |
| w / W               | Forward word / WORD                                       | Motion                                   |
| x / X               | Delete char forward / backward                            | Like Del / Backspace                     |
| y / Y               | Yank (copy) / to EOL                                      | yw, yy, Y                                |
| z                   | Prefix: zz (center), zt/zb (top/bottom), zo/zc/zR (folds) | Scrolling & folding                      |
| ZZ / ZQ             | Write & quit / quit without write                         | Fast quit                                |

**Ctrl in Normal mode (selected)**
- <C-a> / <C-x>     → Increment / decrement number
- <C-b> / <C-f>     → Page up / down
- <C-d> / <C-u>     → Half page down / up
- <C-e> / <C-y>     → Scroll line down / up
- <C-g>             → Show file / line / position stats
- <C-n> / <C-p>     → Down / up one line
- <C-o>             → Jump to older position (back)
- <C-r>             → Redo
- <C-w> hjkl        → Switch windows

**Alt / Meta (<M- / <A- → usually free)**
Common custom maps: <M-hjkl> → switch windows

### Insert Mode – Useful Ctrl & Others
- <C-o>             → Execute one Normal command → return to insert
- <C-n> / <C-p>     → Keyword completion next / previous
- <C-x><C-f>        → File name completion
- <C-x><C-o>        → Omni / LSP completion
- <C-w>             → Delete word backward
- <C-u>             → Delete to start of line
- <C-c>             → Exit insert (like Esc, but different autocmd behavior)

### Visual Mode – Common Letters
- u / U             → Lowercase / Uppercase selection
- ~                 → Toggle case
- d / x             → Delete selection
- y                 → Yank selection
- > / <             → Indent / un-indent lines
- J                 → Join selected lines
- gv                → Reselect previous visual area

### Quit / Exit Commands
- :qa               → Quit all (safe if no changes)
- :qa!              → Force quit all
- :wqa              → Save all & quit
- :wq / ZZ          → Save current & quit
- :bd               → Close current buffer
- LazyVim: <Space>q → Which-key quit menu

## 3. i3 Window Manager – Important Shortcuts

$mod = Super / Win key (check your config)

### Basics
$mod + Enter        → Open terminal
$mod + d            → App launcher (dmenu/rofi/wofi)
$mod + Shift + q    → Close focused window
$mod + Shift + e    → Power / exit menu

### Focus & Movement
$mod + h j k l      → Focus left/down/up/right
$mod + Shift + h j k l → Move focused window

### Layout & Splitting
$mod + v            → Vertical split
$mod + h            → Horizontal split
$mod + f            → Toggle fullscreen
$mod + s / w / e    → Stacked / Tabbed / Toggle split
$mod + Shift + Space → Toggle floating

### Resize
$mod + r            → Enter resize mode
  Then h/l/j/k or arrows → shrink/grow width/height
  Enter/Esc           → Exit mode

Common custom direct resize:
$mod + Ctrl + Right → Grow width
$mod + Ctrl + Left  → Shrink width

### Scratchpad (minimize-like)
$mod + Shift + -    → Move window to scratchpad
$mod + -            → Show / cycle scratchpad

### Suspend / Sleep (add to config)
$mod + Shift + z    → i3lock && systemctl suspend
  (lock screen + suspend)

Reload config:      $mod + Shift + r

## Quick Tips
- Vim counts: 5j = down 5 lines, 3dw = delete 3 words, 10G = line 10
- gu / gU work in LazyVim (guw = lowercase word, gUU = uppercase line)
- Alt + letters and most Shift + letters are free for custom mappings
- Use :help index or :help normal-index for full built-in list
