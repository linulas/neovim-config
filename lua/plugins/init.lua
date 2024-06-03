-- vim:foldmethod=marker

return {
  -- lsp {{{
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    config = function()
      require("configs.lspconfig").init()
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("configs.luasnip").init(opts)
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-cmdline",
      },
    },
    config = function()
      require("configs.cmp").init()
    end,
  },

  { "folke/neodev.nvim", opts = {} },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require("configs.conform").init()
    end,
  },

  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    config = function()
      require("configs.treesitter").init()
    end,
  },

  -- }}}

  -- git {{{
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    config = function()
      require("gitsigns").setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = "DiffviewOpen",
  },
  -- }}}

  -- utilities {{{
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    cond = vim.env.ENABLE_PLUGIN_MASON == "true",
    config = function()
      require("configs.mason").init()
    end,
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTelescope", "TodoTelescope" },
    dependencies = "nvim-lua/plenary.nvim",
    opts = require "configs.todo_comments",
  },

  {
    "phaazon/hop.nvim",
    cmd = { "HopWord", "HopChar1CurrentLine" },
    branch = "v2", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
    end,
  },

  { "lambdalisue/vim-suda", cmd = "SudaWrite" },

  {
    "NvChad/nvterm",
    config = function()
      require("configs.nvterm").init()
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "comment toggle current line" },
      { "gc", mode = { "n", "o" }, desc = "comment toggle linewise" },
      { "gc", mode = "x", desc = "comment toggle linewise (visual)" },
      { "gbc", mode = "n", desc = "comment toggle current block" },
      { "gb", mode = { "n", "o" }, desc = "comment toggle blockwise" },
      { "gb", mode = "x", desc = "comment toggle blockwise (visual)" },
    },
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "kylechui/nvim-surround",
    lazy = false,
    config = function()
      require("nvim-surround").setup {}
    end,
  },
  -- }}}

  -- UI {{{
  {
    "Mofiqul/dracula.nvim",
    -- "rebelot/kanagawa.nvim",
    -- "folke/tokyonight.nvim",
    -- "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd [[colorscheme dracula]]
      -- vim.cmd [[colorscheme cyberdream]]
      -- vim.cmd([[colorscheme tokyonight]])
      -- vim.cmd([[colorscheme kanagawa]])
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
    },
    cmd = "Telescope",
    config = function()
      require("configs.telescope").init()
    end,
  },

  {
    "folke/which-key.nvim",
    keys = { "<leader>", "<c-r>", "<c-w>", '"', "'", "`", "c", "v", "g" },
    cmd = "WhichKey",
    config = function()
      require("which-key").setup()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("configs.lualine").init()
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("configs.nvimtree").init()
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    config = function()
      require("fidget").setup {}
    end,
  },

  { "folke/zen-mode.nvim", cmd = "ZenMode" },
  -- }}}

  -- AI {{{
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPT", "ChatGPTActAs", "ChatGPTEditWithInstructions" },
    config = function()
      require("chatgpt").setup {}
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  -- FIX: Codeium plugin not working atm. Keeping tabs on this PR to be able to diagnose the plugin further:
  -- https://github.com/Exafunction/codeium.nvim/pull/185
  -- {
  --   "Exafunction/codeium.vim",
  --   lazy = false,
  -- },
  -- }}}

  -- debug {{{
  {
    "mfussenegger/nvim-dap",
    event = "BufReadPre",
    module = { "dap" },
    cond = vim.env.ENABLE_PLUGIN_DAP == "true",
    dependencies = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "nvim-telescope/telescope-dap.nvim",
      "nvim-neotest/nvim-nio",
      { "leoluz/nvim-dap-go", module = "dap-go" },
    },
    config = function()
      require("configs.dap").init()
    end,
  },
  -- }}}

  -- notes {{{
  {
    "JellyApple102/flote.nvim",
    cmd = "Flote",
    config = function()
      require("configs.flote").init()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "epwalsh/obsidian.nvim",
    -- version = "*",
    -- lazy = true,
    ft = "markdown",
    cond = vim.env.ENABLE_PLUGIN_OBSIDIAN == "true",
    cmd = {
      "ObsidianQuickSwitch",
      "ObsidianOpen",
      "ObsidianBacklinks",
      "ObsidianTags",
      "ObsidianSearch",
      "ObsidianTemplate",
    },
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
      -- Optional
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("configs.obsidian").init()
    end,
  },
}
