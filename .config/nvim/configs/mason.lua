-- install lspservers, formatters, linters or debug adapters (use :Mason or :MasonInstallAll)
local options = {
    ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "emmet-ls",
        "json-lsp",
        "prettier",

        -- shell
        "shfmt",
        "shellcheck",

        -- cmake
        "cmake-language-server",
        "cmakelang",

        -- cpp
        "clangd",
        "clang-format",

        -- python
        "autopep8",
    },
}

return options
