-- vim:foldmethod=marker
local map = vim.keymap.set

-- ########### Minimal config ########### {{{

-- general
map("i", "jk", "<ESC>")
map("i", "[", "[]<Left>", { noremap = true, silent = true })
map("i", "{", "{}<Left>", { noremap = true, silent = true })
map("i", "(", "()<Left>", { noremap = true, silent = true })
map("i", '"', '""<Left>', { noremap = true, silent = true })
map("i", "'", "''<Left>", { noremap = true, silent = true })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })

map("n", "<leader>ln", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

map({ "n", "i" }, "<C-d>", "<C-d>zz", { desc = "Navigate half down and center cursor" })
map({ "n", "i" }, "<C-u>", "<C-u>zz", { desc = "Navigate half up and center cursor" })

map("n", "s", "<cmd> w <CR>", { desc = "Save current buffer" })
map("n", "S", "<cmd> wa <CR>", { desc = "Save all active buffers" })
map("n", "<ENTER>", "o<ESC>", { desc = "New line" })
-- git
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "Open lazygit" })
map("n", "<leader>gh", "<cmd>LazyGitFilterCurrentFile<cr>", { desc = "Open current buffer commits" })
map("n", "<leader>gc", "<cmd>LazyGitConfig<cr>", { desc = "Open lazygit config" })

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

map("n", "]d", function()
  vim.diagnostic.goto_next { float = { border = "rounded" } }
end, { desc = "Next diagnostic" })

map("n", "[d", function()
  vim.diagnostic.goto_previous { float = { border = "rounded" } }
end, { desc = "Previous diagnostic" })

-- buffer
map("n", "\\", "<cmd>b#<CR>", { desc = "Go to alternate buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })
map("n", "<leader>cb", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all except active buffer" })
map("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close current buffer" })

-- comment
map("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "comment toggle" })

map(
  "v",
  "<leader>/",
  "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
  { desc = "comment toggle" }
)

-- telescope
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "telescope live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
map(
  "n",
  "<leader>fa",
  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope find all files" }
)
map(
  "n",
  "<leader>fs",
  "<cmd>Telescope live_grep follow=true no_ignore=true hidden=true<CR>",
  { desc = "telescope grep all" }
)

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

-- new terminals
map("n", "<leader>h", function()
  require("nvterm.terminal").new "horizontal"
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvterm.terminal").new "vertical"
end, { desc = "terminal new vertical window" })

-- toggleable
map({ "n", "t" }, "<A-v>", function()
  require("nvterm.terminal").toggle "vertical"
end, { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", function()
  require("nvterm.terminal").toggle "horizontal"
end, { desc = "terminal new horizontal term" })

map({ "n", "t" }, "<A-i>", function()
  require("nvterm.terminal").toggle "float"
end, { desc = "terminal toggle floating term" })
-- }}}

-- ########### Extended config ########### {{{
if vim.env.CONFIGURATION_TYPE ~= "minimal" then
  map("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle zen mode" })

  -- git
  map(
    "n",
    "<leader>gb",
    "<cmd>Gitsigns blame_line<cr>",
    { desc = "Show blame information for the current line in popup" }
  )
  map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
  map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
  map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })

  map("n", "]]", function()
    vim.schedule(function()
      require("gitsigns").nav_hunk "next"
    end)
  end, { desc = "Next git hunk" })

  map("n", "[[", function()
    vim.schedule(function()
      require("gitsigns").nav_hunk "prev"
    end)
  end, { desc = "Previous git hunk" })

  -- lsp
  map("n", "<leader>q", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Troubleshoot workspace" })

  -- buffer
  map("n", "f", ":HopWord<cr>", { desc = "Hop word on entire buffer" })

  -- comment
  map("n", "<leader>ft", ":TodoTelescope<cr>", { desc = "Find all comment tags" })
  map("n", "<leader>fq", ":TodoTrouble<cr>", { desc = "Open troble tags" })
  map("n", "<leader>fk", ":TodoTelescope keywords=FIX,TODO,BUG,FIX<cr>", { desc = "Find keyword comment tags" })

  -- nvimtree
  map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

  -- AI
  map("n", "<leader>p", "<cmd>CodeCompanionChat<CR>", { desc = "Open AI chat (Gemini)" })
  map("n", "t", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle AI chat (Gemini)" })
  map("v", "<leader>e", ":CodeCompanion /explain<CR>", { desc = "Explain selection" })
  map("n", ";", ":CodeCompanion ", { desc = "Prompt AI" })
  map("v", ";", ":CodeCompanion ", { desc = "Prompt AI about selection" })

  -- notes
  map("n", "<leader>n", "<cmd>Flote<CR>", { desc = "Project notes" })
  map("n", "<leader>mg", "<cmd>Flote global<CR>", { desc = "Global notes" })
  map("n", "<leader>mn", "<cmd>Flote manage<CR>", { desc = "Manage notes" })

  map("n", "<leader>fn", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Find notes" })
  map("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { desc = "Open current note in Obsidian" })
  map("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>", { desc = "Search references to the current buffer" })
  map("n", "<leader>of", "<cmd>ObsidianTags<CR>", { desc = "Search obsidian tags" })
  map("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Search for (or create) notes in vault" })
  map("n", "<leader>ol", "<cmd>ObsidianLinks<CR>", { desc = "Collect all links within the current buffer" })
  map("n", "<leader>ot", "<cmd>ObsidianTemplate<CR>", { desc = "Pick a obisidian template" })
  map("v", "<leader>ol", ":'<,'>ObsidianLinkNew<CR>", { desc = "Create a new note and link to it" })
  map("v", "<leader>oe", ":'<,'>ObsidianExtractNote<CR>", { desc = "Extract text into new note and link to it" })

  -- debugging
  map("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>", { desc = "Toggle breakpoint" })
  map("n", "<leader>dq", "<cmd>lua require('dap').close()<cr>", { desc = "Quit debugging" })
  map("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle debugging UI" })
  map("n", "<leader>d4", ":lua require('dap').continue()<cr>", { desc = "Start debugging" })
  map({ "n", "i" }, "<A-1>", "<cmd>lua require('dap').step_over()<cr>", { desc = "Step over" })
  map({ "n", "i" }, "<A-2>", "<cmd>lua require('dap').step_into()<cr>", { desc = "Step into" })
  map({ "n", "i" }, "<A-3>", "<cmd>lua require('dap').step_out()<cr>", { desc = "Step out" })
  map({ "n", "i" }, "<A-4>", "<cmd>lua require('dap').continue()<cr>", { desc = "Continue" })
  map({ "n", "i" }, "<A-5>", "<cmd>lua require('dap').continue()<cr>", { desc = "Start debugging" })
end
