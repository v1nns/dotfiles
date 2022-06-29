-- overriding default plugin configs!

local M = {}

M.treesitter = {
    ensure_installed = {
        "vim",
        "html",
        "css",
        "javascript",
        "json",
        "toml",
        "markdown",
        "c",
        "cpp",
        "bash",
        "lua",
        "python"
   },
}

M.nvimtree = {
   git = {
      enable = true,
   },
}

M.cmp = {
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "neorg" },
    },
}

M.blankline = {
    filetype_exclude = {
        "help",
        "terminal",
        "alpha",
        "packer",
        "lspinfo",
        "TelescopePrompt",
        "TelescopeResults",
        "nvchad_cheatsheet",
        "lsp-installer",
        "norg",
        "",
    },
}

M.telescope = {
    extensions_list = { "file_browser" },
}

return M
