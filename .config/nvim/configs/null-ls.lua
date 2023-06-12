local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local lint = null_ls.builtins.diagnostics

local sources = {
    -- Prettier
    formatting.deno_fmt,
    formatting.prettierd.with({ filetypes = { "html", "markdown", "css" } }),

    -- Lua
    formatting.stylua.with({
        extra_args = { "--column-width", "100", "--indent-type", "Spaces" },
    }),

    -- Cpp
    formatting.clang_format.with({
        extra_args = {
            "--style",
            "{BasedOnStyle: Google, Standard: c++17, ColumnLimit: 100}",
        },
    }),

    -- Shell
    formatting.shfmt,
    lint.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

    -- CMake
    formatting.cmake_format,

    -- Python
    formatting.autopep8.with({
        extra_args = {
            "--max-line-length",
            "100",
        },
    }),
}

null_ls.setup({
    debug = true,
    sources = sources,

    -- on init
    on_init = function(new_client, _)
        new_client.offset_encoding = "utf-32"
    end,
})
