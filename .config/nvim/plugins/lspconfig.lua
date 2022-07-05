-- lsp configs!

local M = {}

local symbol_highlight = function(client)
    -- add syntax highlight for current symbol
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
                hi! LspReferenceRead cterm=bold ctermbg=63 guibg=SteelBlue guifg=#e3f2fd
                hi! LspReferenceText cterm=bold ctermbg=63 guibg=SteelBlue guifg=#e3f2fd
                hi! LspReferenceWrite cterm=bold ctermbg=63 guibg=SteelBlue guifg=#e3f2fd
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

M.setup_lsp = function(attach, capabilities)
    local lspconfig = require("lspconfig")

    -- lspservers with default config
    local servers = { "html", "cssls" }

    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
            on_attach = function(client, bufnr)
                attach(client, bufnr)
                symbol_highlight(client)
            end,
            capabilities = capabilities,
        })
    end

    -- lspserver with custom config for ccls
    lspconfig.ccls.setup({
        on_attach = function(client, bufnr)
            attach(client, bufnr)
            symbol_highlight(client)
        end,
        capabilities = capabilities,
        init_options = {
            compilationDatabaseDirectory = "build",
            cache = {
                directory = "/home/vinicius/.cache/ccls",
            },
            clang = {
                excludeArgs = { "-frounding-math" },
            },
            filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda" },
        },
    })
end

return M
