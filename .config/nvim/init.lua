-- enable title
vim.opt.title = true

-- show trailing spaces and tabs
vim.opt.list = true
vim.opt.listchars = {
    trail = "~", --[[ tab = ">>" ]]
}

-- change character and highlight group for git diff view
vim.opt.fillchars = { eob = " ", diff = "⣿" }
vim.cmd([[hi DiffText cterm=bold gui=bold guibg=#545c7e]])

-- change character for indent_blankline, to use a 6-dot braille cell
vim.g.indent_blankline_char = "⡇"
-- vim.g.indent_blankline_context_char = "⣿"

-- setup commands
require("custom.commands").setup_autocommands()
require("custom.commands").setup_commands()

-- to debug lspconfig, use this below and :LspLog
-- vim.lsp.set_log_level("debug")
