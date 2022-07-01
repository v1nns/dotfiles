-- lsp configs!

local M = {}

M.setup_lsp = function(attach, capabilities)
    local lspconfig = require "lspconfig"

    -- lspservers with default config
    local servers = { "html", "cssls"}

    for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = function(client, bufnr)
          attach(client, bufnr)
          require 'illuminate'.on_attach(client)
        end,
        capabilities = capabilities,
    }
    end

    -- lspserver with custom config for ccls
    lspconfig["ccls"].setup {
        on_attach = function(client, bufnr)
          attach(client, bufnr)
          require 'illuminate'.on_attach(client)
        end,
        capabilities = capabilities,
        init_options = {
            compilationDatabaseDirectory = "build",
            cache = {
                directory = "/home/vinicius/.cache/ccls";
            },
            clang = {
                excludeArgs = { "-frounding-math" },
            },
            filetypes = { "c", "cc", "cpp", "objc", "objcpp", "cuda" },
        },
    }
end

return M
