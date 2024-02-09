-- lsp configs
local on_attach = require("plugins.configs.lspconfig").on_attach
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")
local navic = require("nvim-navic")

local symbol_highlight = function(client, bufnr)
  -- add syntax highlight for current symbol
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = vim.lsp.buf.document_highlight,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Document Highlight",
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = vim.lsp.buf.clear_references,
      buffer = bufnr,
      group = "lsp_document_highlight",
      desc = "Clear All the References",
    })
  end
end

local servers = { "html", "bashls", "cssls", "cmake", "clangd", "jsonls", "pylsp" }

for _, lsp in ipairs(servers) do
  local settings = {}
  if lsp == "pylsp" then
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = {
            ignore = { "E501" },
            maxLineLength = 100,
          },
        },
      },
    }
  end

  lspconfig[lsp].setup({
    settings = settings,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      if lsp == "cmake" then
        return
      end

      -- enable breadcrumb
      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
      end

      -- enable symbol highlight
      symbol_highlight(client, bufnr)
    end,
    capabilities = capabilities,
  })
end
