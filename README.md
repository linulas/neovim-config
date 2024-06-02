# Linulas neovim config

**Plugins overview**:
- LSP
    - [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
    - [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
    - [neodev.nvim](https://github.com/folke/neodev.nvim)
    - [conform.nvim](https://github.com/stevearc/conform.nvim)
    - [trouble.nvim](https://github.com/folke/trouble.nvim)
    - [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) 
- Git
    - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) 
    - [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) 
    - [diffview.nvim](https://github.com/sindrets/diffview.nvim) 
- Utilities
    - [mason.nvim](https://github.com/williamboman/mason.nvim) 
    - [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) 
    - [hop.nvim](https://github.com/hadronized/hop.nvim) 
    - [vim-suda](https://github.com/lambdalisue/vim-suda) 
    - [nvterm](https://github.com/zbirenbaum/nvterm) 
    - [comment.nvim](https://github.com/numToStr/Comment.nvim) [mason.nvim](https://github.com/kdheepak/lazygit.nvim) 
    - [nvim-surround](https://github.com/kylechui/nvim-surround)
- UI
    - [dracula.nvim](https://github.com/Mofiqul/dracula.nvim) 
    - [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) 
    - [which-key.nvim](https://github.com/folke/which-key.nvim) 
    - [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) 
    - [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) 
    - [figdget.nvim](https://github.com/j-hui/fidget.nvim) 
    - [zen-mode.nvim](https://github.com/folke/zen-mode.nvim) 
- AI
    - [chatgpt.nvim](https://github.com/jackMort/ChatGPT.nvim) 
- Debug
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap) 
- Notes
    - [flote.nvim](https://github.com/JellyApple102/flote.nvim) 
    - [nvim-dap](https://github.com/mfussenegger/nvim-dap) 
    - [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) 
    

## Pre-requisites
- Neovim 0.10
- Nerd Font as your terminal font
- Ripgrep is required for grep searching with Telescope (OPTIONAL).
- GCC, Windows users must have mingw installed and set on path

## Install

Install on Unix systems
```shell
git clone https://github.com/linulas/neovim-config ~/.config/nvim && nvim
```

Install on Windows
```bash
# If you're using Command Prompt(CMD)
git clone https://github.com/linulas/neovim-config %USERPROFILE%\AppData\Local\nvim && nvim

# If you're using PowerShell(pwsh)
git clone https://github.com/linulas/neovim-config $ENV:USERPROFILE\AppData\Local\nvim && nvim
```

Install all packages listed in ./lua/configs/mason.lua
```vim
:MasonInsallAll
```

## Configuration

Default configuration from ./lua/bootstrap.lua:
```lua
local default_settings = {
  ENABLE_PLUGIN_MASON = true,
  ENABLE_PLUGIN_DAP = true,
  LLDB_PATH = "/usr/local/opt/llvm/bin/lldb-vscode",
}
```

To override the defaults, create <nvim_config_path>/.env and pass the desired settings
```bash
ENABLE_PLUGIN_MASON=false
LLDB_PATH=/run/current-system/sw/bin/lldb-vscode
```

## Uninstall

```bash
# Linux / Macos (unix)
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim

# Windows CMD
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

# Window PowerShell
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data
```
