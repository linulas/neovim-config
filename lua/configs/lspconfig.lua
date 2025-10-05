local M = {}
local map = vim.keymap.set

-- NOTE: Available configuration servers: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "csharp_ls",
  "cssls",
  "eslint",
  "gopls",
  "html",
  "phpactor",
  "jsonls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "rust_analyzer",
  "svelte",
  "ts_ls",
  "volar",
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
  ---@diagnostic disable-next-line: missing-fields
  require("neodev").setup {}

  for _, lsp in ipairs(servers) do
    if lsp == "rust_analyzer" then
      vim.lsp.config("rust_analyzer", {
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
      })
    elseif lsp == "ts_ls" then
      vim.lsp.config("ts_ls", {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vim.env.TYPESCRIPT_PLUGIN_PATH,
              languages = { "javascript", "typescript", "vue" },
            },
          },
        },
        filetypes = {
          "javascript",
          "typescript",
          "vue",
        },
      })
    elseif lsp == "eslint" then
      local customizations = {
        { rule = "style/*", severity = "off", fixable = true },
        { rule = "format/*", severity = "off", fixable = true },
        { rule = "*-indent", severity = "off", fixable = true },
        { rule = "*-spacing", severity = "off", fixable = true },
        { rule = "*-spaces", severity = "off", fixable = true },
        { rule = "*-order", severity = "off", fixable = true },
        { rule = "*-dangle", severity = "off", fixable = true },
        { rule = "*-newline", severity = "off", fixable = true },
        { rule = "*quotes", severity = "off", fixable = true },
        { rule = "*semi", severity = "off", fixable = true },
      }
      vim.lsp.config("eslint", {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          "vue",
          "html",
          "markdown",
          "json",
          "jsonc",
          "yaml",
          "toml",
          "xml",
          "gql",
          "graphql",
          "astro",
          "svelte",
          "css",
          "less",
          "scss",
          "pcss",
          "postcss",
        },
        settings = {
          -- Silent the stylistic rules in you IDE, but still auto fix them
          rulesCustomizations = customizations,
        },
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })
    else
      -- lsps with default config
      vim.lsp.config(lsp, {
        on_attach = on_attach_default,
        on_init = on_init_default,
        capabilities = capabilities_default,
      })
    end
  end
end

M.servers = servers

return M
