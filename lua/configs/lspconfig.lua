local M = {}
local map = vim.keymap.set

-- NOTE: Available configuration servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "cssls",
  "html",
  "lua_ls",
  "marksman",
  "nil_ls",
  "rust_analyzer",
  "svelte",
  "tsserver",
}

local function get_rust_analyzer_features()
  local tbl = {}
  for value in vim.env.RUST_ANALYZER_FEATURES:gmatch "[^,]+" do
    table.insert(tbl, value)
  end
end

local function apply(curr, win)
  local newName = vim.trim(vim.fn.getline ".")
  vim.api.nvim_win_close(win, true)

  if #newName > 0 and newName ~= curr then
    local params = vim.lsp.util.make_position_params()
    params.newName = newName

    vim.lsp.buf_request(0, "textDocument/rename", params)
  end
end

local rename = function()
  local currName = vim.fn.expand "<cword>" .. " "

  local win = require("plenary.popup").create(currName, {
    title = "Renamer",
    style = "minimal",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    relative = "cursor",
    borderhighlight = "RenamerBorder",
    titlehighlight = "RenamerTitle",
    focusable = true,
    width = 25,
    height = 1,
    line = "cursor+2",
    col = "cursor-1",
  })

  vim.cmd "normal A"
  vim.cmd "startinsert"

  map({ "i", "n" }, "<Esc>", "<cmd>q<CR>", { buffer = 0 })
  map({ "i", "n" }, "<CR>", function()
    apply(currName, win)
    vim.cmd.stopinsert()
  end, { buffer = 0 })
end

local on_attach_default = function(_, bufnr)
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end

  map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
  map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
  map("n", "gr", vim.lsp.buf.references, opts "Show references")
  map("n", "K", vim.lsp.buf.hover, {})
  map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map("n", "<leader>ra", function()
    rename()
  end, opts "Renamer")
end

-- disable semanticTokens
local on_init_default = function(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities_default = vim.lsp.protocol.make_client_capabilities()

capabilities_default.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.init = function()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focusable = false,
    relative = "cursor",
    silent = true,
  })

  -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
  require("neodev").setup {}
  local lspconfig = require "lspconfig"

  for _, lsp in ipairs(servers) do
    if lsp == "rust_analyzer" then
      lspconfig.rust_analyzer.setup {
        on_attach = on_attach_default,
        capabilities = capabilities_default,
        settings = {
          ["rust-analyzer"] = {
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
            cargo = {
              buildScripts = {
                enable = true,
              },
              features = get_rust_analyzer_features(),
            },
            procMacro = {
              enable = true,
            },
          },
        },
      }
    else
      -- lsps with default config
      lspconfig[lsp].setup {
        on_attach = on_attach_default,
        on_init = on_init_default,
        capabilities = capabilities_default,
      }
    end
  end
end

M.servers = servers

return M
