-- lsp configs!
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local navic = require("nvim-navic")

local symbol_highlight = function(client)
  -- add syntax highlight for current symbol
  if client.server_capabilities.documentHighlightProvider then
    vim.cmd([[
                hi! LspReferenceRead cterm=bold guibg=#2f3549 guifg=none
                hi! LspReferenceText cterm=bold guibg=#2f3549 guifg=none
                hi! LspReferenceWrite cterm=bold guibg=#2f3549 guifg=none
              ]])
    vim.api.nvim_create_augroup("lsp_document_highlight", {})
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "lsp_document_highlight",
      buffer = 0,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = 0,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

local servers = { "html", "cssls", "clangd", "pylsp" }

for _, lsp in ipairs(servers) do
  capabilities.offsetEncoding = { "utf-32" }

  lspconfig[lsp].setup({
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      navic.attach(client, bufnr)
      symbol_highlight(client)
    end,
    capabilities = capabilities,
  })
end
