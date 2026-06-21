# My Neovim IDE Config

A from-scratch, fully-commented Neovim setup that turns Neovim into a complete IDE
for **React / JavaScript / TypeScript**, **Java**, and most other languages — with
a **Sublime Text (Monokai)** theme and **Mermaid diagram** preview in the browser.

It's **portable**: clone it onto any Linux machine (or macOS) and run. This README
is a step-by-step playbook — follow it top to bottom on a fresh machine and you're done.

> **Brand new to Neovim?** Jump to the [Neovim crash course](#-neovim-crash-course-2-min)
> at the bottom first, then come back.

---

## 📑 Table of contents
1. [What's in here](#-whats-in-here)
2. [The whole setup in one glance](#-the-whole-setup-in-one-glance)
3. [Step 1 — Install system prerequisites](#-step-1--install-system-prerequisites)
4. [Step 2 — Install a Nerd Font (fixes `?` icons)](#-step-2--install-a-nerd-font-fixes--icons)
5. [Step 3 — Set your terminal's font](#-step-3--set-your-terminals-font)
6. [Step 4 — Install this config](#-step-4--install-this-config)
7. [Step 5 — First launch](#-step-5--first-launch)
8. [Step 6 — Verify everything works](#-step-6--verify-everything-works)
9. [Daily cheat sheet](#-daily-cheat-sheet)
10. [Terminal inside Neovim](#-terminal-inside-neovim)
11. [Copy & paste](#-copy--paste)
12. [Jumping to a line / column](#-jumping-to-a-line--column)
13. [Click-to-navigate (Ctrl+click / double-click)](#-click-to-navigate)
14. [Java: how to open projects so imports & `gd` work](#-java-how-to-open-projects-so-imports--gd-work)
15. [Viewing Mermaid diagrams](#-viewing-mermaid-diagrams)
16. [Changing the theme](#-changing-the-theme)
17. [Adding another language](#-adding-another-language)
18. [Updating / sharing across machines](#-updating--sharing-across-machines)
19. [Troubleshooting (every issue we hit)](#-troubleshooting-every-issue-we-hit)
20. [Neovim crash course](#-neovim-crash-course-2-min)

---

## 📁 What's in here

```
.
├── init.lua                  # entry point — loads everything below
├── lua/
│   ├── config/
│   │   ├── options.lua        # editor settings (numbers, tabs, search…)
│   │   ├── keymaps.lua        # global keyboard shortcuts
│   │   ├── autocmds.lua       # automatic behaviours (trim whitespace on save…)
│   │   └── lazy.lua           # installs the plugin manager (lazy.nvim)
│   └── plugins/               # one file per feature; drop a new file to add a plugin
│       ├── colorscheme.lua    # theme — Sublime/Monokai (monokai-pro)
│       ├── treesitter.lua     # accurate syntax highlighting
│       ├── lsp.lua            # ⭐ language intelligence (Mason + LSP servers)
│       ├── completion.lua     # autocomplete popup (blink.cmp)
│       ├── telescope.lua      # fuzzy finder (find files / search text)
│       ├── neo-tree.lua       # file explorer sidebar
│       ├── editor.lua         # statusline, git signs, which-key, autopairs…
│       ├── formatting.lua     # auto-format on save (Prettier / Stylua)
│       ├── java.lua           # Java language server (nvim-jdtls)
│       └── markdown.lua       # Markdown + Mermaid browser preview
└── ftplugin/
    └── java.lua               # per-project Java server startup
```

**How config loading works:** Neovim reads `init.lua`, which loads `lua/config/*`,
then lazy.nvim auto-loads **every** file in `lua/plugins/`. To add a plugin later,
just drop a new `.lua` file in that folder — no other wiring needed.

---

## 🗺 The whole setup in one glance

| Layer | Tool | Installed by |
|-------|------|--------------|
| Editor | Neovim 0.11+ | your OS package manager / brew |
| Plugin manager | lazy.nvim | auto-installs itself on first launch |
| Language intelligence | LSP servers (ts, java, lua, html, css…) | **Mason**, automatically, on first file open |
| Formatters | prettierd, stylua | Mason |
| Search | ripgrep + fd | OS package manager |
| Syntax parsers | tree-sitter CLI (compiles parsers) | npm / brew / pacman |
| Icons | a Nerd Font | OS / brew + terminal setting |
| Runtimes | Node (React/TS), Java 17+ (Java) | nvm / SDKMAN |

You install the **bold/OS** rows by hand (Steps 1–3). Everything else installs
itself the first time you launch Neovim.

---

## ✅ Step 1 — Install system prerequisites

Pick your OS. These are command-line tools Neovim relies on (search, compilers,
language runtimes) — **not** Neovim plugins.

### Linux — Debian / Ubuntu
```bash
# Neovim 0.11+ (the version in plain apt is usually too old — use the PPA)
sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt update
sudo apt install -y neovim git ripgrep fd-find unzip curl build-essential xclip

# NOTE: on Debian/Ubuntu the 'fd' binary is called 'fdfind'. Make a real 'fd':
mkdir -p ~/.local/bin && ln -sf "$(which fdfind)" ~/.local/bin/fd
# ensure ~/.local/bin is on PATH (add to ~/.bashrc/~/.zshrc if not):  export PATH="$HOME/.local/bin:$PATH"

# Node.js (for React/TS servers + Mermaid preview) via nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
exec $SHELL              # reload shell so nvm is available
nvm install --lts        # installs the latest LTS Node

# Java 17+ (for the Java language server) via SDKMAN:
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.9-tem

# tree-sitter CLI — REQUIRED to compile syntax parsers (nvim-treesitter `main` branch).
# Easiest cross-distro install is via npm (you just installed Node):
npm install -g tree-sitter-cli
```

### Linux — Arch
```bash
sudo pacman -S neovim git ripgrep fd unzip curl base-devel xclip nodejs npm jdk21-openjdk tree-sitter-cli
```

### macOS (Homebrew)
```bash
# Editor + search tools + tree-sitter CLI (we installed exactly these):
brew install neovim ripgrep fd tree-sitter-cli

# Runtimes (install if you don't already have them):
# Node via nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
exec $SHELL && nvm install --lts
# Java via SDKMAN:
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java 21.0.9-tem
```

**Quick sanity check** (all should print a version, none should say "not found"):
```bash
nvim --version | head -1; git --version; rg --version | head -1; fd --version; node -v; java -version
```

---

## 🔤 Step 2 — Install a Nerd Font (fixes `?` icons)

Neovim's icons (file tree, statusline, git symbols) need a **Nerd Font**. Without
one you'll see `?` boxes. Install one:

### macOS
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Linux
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip && rm JetBrainsMono.zip
fc-cache -fv
```

---

## 🖥 Step 3 — Set your terminal's font

Installing the font isn't enough — your **terminal app** must be told to *use* it.
This is a terminal setting, not a Neovim setting.

### iTerm2 (macOS)
1. Press **⌘ ,** (Settings) → **Profiles** → **Text** tab.
2. Under **Font**, pick **`JetBrainsMono Nerd Font Mono`**.
3. If it's not in the list, fully quit iTerm2 (**⌘Q**) and reopen — it rescans fonts on launch.

### GNOME Terminal / Konsole / Alacritty / WezTerm (Linux)
Set the profile/config font to **`JetBrainsMono Nerd Font Mono`** (or `JetBrainsMonoNL Nerd Font`).
For Alacritty/WezTerm it's a line in their config file; for GNOME Terminal/Konsole it's
in the profile preferences GUI.

> After changing the font, fully quit and reopen the terminal, then reopen Neovim.

---

## 📥 Step 4 — Install this config

Neovim reads its config from `~/.config/nvim`. We keep the config in **this git repo**
and point Neovim at it, so updates are just `git pull`.

```bash
# 1) Back up any existing config (safe even if there's none)
[ -e ~/.config/nvim ] && [ ! -L ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak.$(date +%s)
mkdir -p ~/.config

# 2a) FIRST machine — this folder IS your config. Symlink it into place.
#     Run this from INSIDE this repo folder:
ln -sfn "$(pwd)" ~/.config/nvim

# 2b) ANOTHER machine — clone your repo straight into place instead:
#     git clone <your-repo-url> ~/.config/nvim
```

---

## 🚀 Step 5 — First launch

```bash
nvim
```

On the very first launch, in order:
1. **lazy.nvim installs itself**, then downloads all ~18 plugins (you'll see a progress UI).
2. Plugins build their native bits (Treesitter parsers, the fuzzy matcher, etc.).
3. When you first open a code file, **Mason auto-downloads the language servers**
   (TypeScript, Java/jdtls, Lua, HTML, CSS, Tailwind, JSON, YAML, Bash) and the
   formatters (prettierd, stylua). This runs in the background — give it a minute.

> Tip: after the first plugin install finishes, **quit and reopen** (`:qa` then `nvim`)
> once, so everything is freshly loaded.

To force/inspect installs manually:
```
:Lazy      " plugin manager dashboard — press  U  to update, S to sync, q to close
:Mason     " language servers & tools — see what's installed / installing
```

---

## ✅ Step 6 — Verify everything works

Inside Neovim:
```
:checkhealth        " overall health report — fix anything shown in red
:Mason              " confirm servers/formatters are installed (not just queued)
:checkhealth vim.lsp" confirm the LSP subsystem is happy
```

Open a real file and confirm intelligence works:
```bash
nvim somefile.ts        # or a .tsx / .java inside a project
```
- Put the cursor on a symbol → press **`gd`** → it should jump to the definition.
- Check a server is attached:
  ```
  :lua print(#vim.lsp.get_clients() .. " LSP client(s) attached")
  ```
  `1` (or more) = good. `0` = server not installed/attached (see Troubleshooting).

---

## ⌨️ Daily cheat sheet

`<leader>` is the **Spacebar**. Press Space and **pause** — a menu (which-key) pops
up showing every option, so you never have to memorize anything.

| Keys | Does |
|------|------|
| `<leader>ff` | Find files by name (use this constantly) |
| `<leader>fg` | Search text across the whole project (grep) |
| `<leader>fb` | Switch between open files (buffers) |
| `<leader>fr` | Recently opened files |
| `<leader>fe` | **Toggle the file-explorer sidebar** |
| `<leader>fo` | Focus into the file explorer |
| `<leader><leader>` | Quick find files |
| `gd` | Go to definition |
| `gr` | Find all references |
| `gi` | Go to implementation |
| `K` | Show hover documentation |
| `<leader>cr` | Rename a symbol everywhere |
| `<leader>ca` | Code action / quick fix (e.g. "Import 'X'") |
| `<leader>cf` | Format the current file now |
| `[d` / `]d` | Jump to previous / next error |
| `<leader>e` | Show the error message on this line |
| `gcc` | Comment/uncomment a line (`gc` in visual mode) |
| `<C-h/j/k/l>` | Move between split windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<C-o>` / `<C-i>` | Jump back / forward (after a `gd`) |
| `s` then 2 chars | **Flash jump** — teleport anywhere on screen |
| `Ctrl+\` | **Toggle a terminal** (float). `<Esc><Esc>` to exit it |
| `<leader>tf/th/tv` | Terminal float / below / right |
| `<leader>mp` | **Mermaid/Markdown browser preview** (in a `.md` file) |
| `<leader>w` / `<leader>q` | Save / quit |

Inside any Telescope picker, press `<C-/>` (insert mode) to see its own shortcuts.
Inside the file tree, press `?` to see its keys (`a` add, `d` delete, `r` rename).

---

## 🖥 Terminal inside Neovim

Provided by **toggleterm** (plus Neovim's built-in `:terminal`).

| Keys | Does |
|------|------|
| `Ctrl + \` | Toggle a floating terminal open/closed |
| `<leader>tf` | Terminal as a floating window |
| `<leader>th` | Terminal in a split **below** |
| `<leader>tv` | Terminal in a split on the **right** |
| `<Esc><Esc>` | Leave terminal "insert" mode → back to Normal mode |

Built-in alternative (no plugin): `:terminal`, or `:split | terminal` / `:vsplit | terminal`.

---

## 📋 Copy & paste

Your config syncs Neovim's yank/paste with the **system clipboard**
(`clipboard = unnamedplus`), so copying here works in other apps and vice versa.
(On Linux this needs `xclip` or `wl-clipboard` installed — included in Step 1.)

| Action | Keys |
|--------|------|
| Copy (yank) a selection | select with `v` + motion, then `y` |
| Copy the current line | `yy` |
| Copy a word under cursor | `yiw` |
| Cut a line / selection | `dd` / `d` |
| Paste after / before cursor | `p` / `P` |
| Undo / redo | `u` / `Ctrl+r` |

- What you `y` here can be pasted into other apps with ⌘V / Ctrl+V, and what you
  copy elsewhere can be pasted here with `p`.
- ⚠️ In Neovim, **`Ctrl+V` is NOT paste** — it starts "visual block" selection. Use `p` to paste.

---

## 🎯 Jumping to a line / column

| Goal | How |
|------|-----|
| Go to line N | `:N` + Enter (e.g. `:42`), or `42G` |
| Top / bottom of file | `gg` / `G` |
| Go to column N | `N|` (pipe), e.g. `10|` |
| Line **and** column | `42G` then `10|` |
| Teleport anywhere on screen | **`s`** then type 2 chars near the target, then the label letter (flash.nvim) |

---

## 🖱 Click-to-navigate

Three ways to jump to a definition — use whichever you like:

| Method | Works where |
|--------|-------------|
| **`gd`** (keyboard) | everywhere — the reliable, recommended way |
| **Double-click** a symbol | works in a terminal (iTerm2) too |
| **Ctrl+click** a symbol | **GUI only** (Neovide / graphics terminals) |

**Why Ctrl+click does nothing in iTerm2:** on macOS, Control+click *is* a right-click,
and the terminal pops its own context menu before Neovim ever sees the click. Cmd+click
is likewise grabbed by iTerm. So in a terminal, use **double-click** or **`gd`**.
For real Ctrl+click, run a GUI Neovim like **Neovide** (`brew install neovide`) — it uses
this same config and receives modifier-clicks properly. Press **`<C-o>`** to jump back.

---

## ☕ Java: how to open projects so imports & `gd` work

Java's server (jdtls) is pickier than the others. Two rules:

**1. Open a PROJECT, not a loose file.** jdtls needs a `pom.xml`, `build.gradle`, or
`.git` at the root. Opening a single `.java` file outside a project = no classpath,
so imports (even your own classes) won't resolve.
```bash
cd /path/to/your/java-project    # the folder containing pom.xml / build.gradle
nvim .
```

**2. Wait for the first-time import.** On first open, jdtls downloads dependencies and
builds an index. Until that finishes, `gd` into libraries does nothing. Watch the bottom
of the screen / `:messages`; big projects can take a few minutes.

**Verify jdtls attached** (open a `.java` file in the project, then):
```
:lua print(#vim.lsp.get_clients({name='jdtls'}))                       -- should print 1
:lua print(vim.lsp.get_clients({name='jdtls'})[1].config.root_dir)     -- should be YOUR project root
```

**Imports & navigation tips:**
- Unresolved import (red squiggle)? Cursor on it → **`<leader>ca`** → "Import 'X'".
- `gd` into a JDK class (e.g. `java.util.List`) opens a *decompiled* read-only view — that's normal and working.
- Changed `pom.xml` / `build.gradle`? Refresh dependencies:
  `:lua require('jdtls').update_projects_config()`

---

## 📊 Viewing Mermaid diagrams

1. Open/create a Markdown file, e.g. `notes.md`.
2. Add a mermaid block:
   ````markdown
   ```mermaid
   graph TD
     A[Start] --> B{Works?}
     B -->|Yes| C[Ship it]
     B -->|No| D[Fix it] --> B
   ```
   ````
3. Press **`<leader>mp`**. Your browser opens and renders the diagram live; it updates
   as you type. Press `<leader>mp` again to stop.
4. **`<leader>mr`** toggles a prettified in-editor markdown view (headings, tables…).

---

## 🎨 Changing the theme

The theme is **tender** (`jacoborus/tender.vim`), a warm dark theme, set in
`lua/plugins/colorscheme.lua`. The config also forces a light cursor so it stays
visible on the dark background.

- **Tip:** since it's dark, the background is tender's own `#282828` (not the
  terminal's). To instead inherit your terminal background, you'd switch to a theme
  with a `transparent` option.
- **Totally different theme?** Replace the plugin in that file. Popular options:
  `navarasu/onedark.nvim` (One Dark — the single most-used dev theme),
  `folke/tokyonight.nvim`, `catppuccin/nvim`, `Mofiqul/dracula.nvim`,
  `projekt0n/github-nvim-theme` (light/dark GitHub). Update the
  `vim.cmd.colorscheme(...)` call to match. The statusline uses `theme = "auto"`,
  so it adapts to whatever colorscheme you pick.

---

## ➕ Adding another language

Usually just two edits:
1. **Treesitter parser** — add the language name to `ensure_installed` in
   `lua/plugins/treesitter.lua`.
2. **LSP server** — add its name to the `servers` list in `lua/plugins/lsp.lua`.
   Find server names at <https://github.com/neovim/nvim-lspconfig> — e.g.
   `pyright` (Python), `gopls` (Go), `rust_analyzer` (Rust), `clangd` (C/C++).
3. *(Optional)* add a formatter in `lua/plugins/formatting.lua` and to the
   `mason-tool-installer` list in `lua/plugins/lsp.lua`.

Restart Neovim; Mason installs the new server automatically the next time you open
a matching file.

---

## 🔁 Updating / sharing across machines

**Make it a repo and push it** (do this once):
```bash
cd ~/.config/nvim            # or this repo folder
git init
git add -A
git commit -m "My Neovim IDE config"
git branch -M main
git remote add origin <your-repo-url>
git push -u origin main
```
We commit **`lazy-lock.json`** on purpose — it pins exact plugin versions so every
machine installs identical plugins.

**On a new machine:** do Steps 1–3 (prereqs + font), then:
```bash
git clone <your-repo-url> ~/.config/nvim
nvim        # plugins + servers auto-install
```

**Update plugins later:** inside Neovim run `:Lazy` then press `U` (update), or `S` (sync).
After updating, `git add lazy-lock.json && git commit` to share the new pinned versions.

**Roll back a bad update:** `:Lazy restore` reinstalls the versions in `lazy-lock.json`.

---

## 🔧 Troubleshooting (every issue we hit)

| Symptom | Cause & fix |
|---------|-------------|
| **`?` boxes instead of icons** | Terminal font isn't a Nerd Font. Do [Step 2](#-step-2--install-a-nerd-font-fixes--icons) + [Step 3](#-step-3--set-your-terminals-font), then reopen the terminal. |
| **No file tree / "folder structure"** | It's a toggled sidebar. Press **Space → f → e** (`<leader>fe`). Or just use **Space → f → f** to fuzzy-find files. |
| **`...failed to spawn yaml-language-server / not installed`** | The server was still downloading. Wait, check `:Mason`. (Config already enables servers only *after* Mason installs them, so this is transient on first run.) |
| **Treesitter error: "Parser not available for jsx"** | Already fixed — `jsx` isn't a real parser (JSX is covered by `javascript`; TSX by `tsx`). |
| **Treesitter crash: `attempt to call method 'range' (a nil value)`** | The frozen `master` branch doesn't support Neovim 0.12+. We use the `main` branch (set in `treesitter.lua`). If parsers won't compile (`ENOENT: 'tree-sitter'`), install the **tree-sitter CLI**: `npm install -g tree-sitter-cli` (or `brew install tree-sitter-cli`), then `:TSUpdate`. |
| **Ctrl+click doesn't go to definition** | In a terminal, iTerm2 turns Ctrl+click into a right-click menu. Use **double-click** or **`gd`**; for real Ctrl+click use Neovide. See [Click-to-navigate](#-click-to-navigate). |
| **Java `gd` / imports don't resolve** | Open the **project folder** (with `pom.xml`/`build.gradle`), not a single file, and **wait for indexing**. See [Java section](#-java-how-to-open-projects-so-imports--gd-work). |
| **`<leader>mp` / Markdown preview won't open the browser** | The preview server binary didn't download (empty `app/bin/`). Fix inside Neovim: `:call mkdp#util#install()`, or from a shell: `cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app && bash install.sh`. Also ensure you're in a `.md` file. |
| **`gd` does nothing in any language** | No server attached. `:lua print(#vim.lsp.get_clients())` → if `0`, check `:Mason` (is the server installed?) and `:checkhealth vim.lsp`. |
| **`fd`/`rg` warnings in `:checkhealth`** | Install ripgrep & fd ([Step 1](#-step-1--install-system-prerequisites)); on Debian/Ubuntu remember the `fdfind`→`fd` symlink. |
| **Cursor invisible on the light theme** | Already fixed in `colorscheme.lua` (forces a black cursor). If it still blends in, it's iTerm2 overriding: Settings → Profiles → Colors → Cursor Colors → set Cursor to black + uncheck "Smart cursor color". |
| **A plugin broke after updating** | `:Lazy restore` rolls back to the pinned `lazy-lock.json` versions. |
| **Reset one language server** | `:LspRestart`. |

---

## 🧠 Neovim crash course (2 min)

Neovim is **modal** — keys do different things per mode:

- **Normal mode** (default; press `<Esc>` to return): keys are commands.
  `h j k l` move; `w`/`b` jump word forward/back; `dd` delete line; `yy` copy ("yank");
  `p` paste; `u` undo; `<C-r>` redo.
- **Insert mode** (`i`): type text like a normal editor. `<Esc>` to leave.
- **Visual mode** (`v`): select text, then act (`d`, `y`, `>` …).
- **Command mode** (`:`): `:w` save, `:q` quit, `:wq` both, `:q!` quit without saving.

Stuck? Mash `<Esc>` a couple times to get to Normal mode, then `:q!` to bail out.

**Best 25 minutes you can spend:** run `:Tutor` inside Neovim.
