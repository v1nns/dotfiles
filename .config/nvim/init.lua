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

-- setup commands
require("custom.commands").setup_autocommands()
require("custom.commands").setup_commands()

-- to debug lspconfig, use this below and :LspLog
-- vim.lsp.set_log_level("debug")
