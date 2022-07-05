local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {

    b.formatting.deno_fmt,
    b.formatting.prettierd.with({ filetypes = { "html", "markdown", "css" } }),

    -- Lua
    b.formatting.stylua,
    b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
    b.formatting.stylua.with({
        extra_args = { "--column-width", "80", "--indent-type", "Spaces" },
    }),

    -- Cpp
    b.formatting.clang_format,
    b.formatting.clang_format.with({
        extra_args = {
            "-style",
            "{BasedOnStyle: Google, Standard: c++17 ,ColumnLimit: 100}",
        },
    }),

    -- Shell
    b.formatting.shfmt,
    b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    debug = true,
    sources = sources,

    -- on init
    on_init = function(new_client, _)
        new_client.offset_encoding = "utf-32"
    end,

    -- format on save
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        filter = function(cli)
                            return cli.name == "null-ls"
                        end,
                    })
                end,
            })
        end
    end,
})
