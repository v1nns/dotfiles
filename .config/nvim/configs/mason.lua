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

    -- shell
    "shfmt",
    "shellcheck",

    -- cpp
    "clangd",
    "clang-format",
  },
}

return options
