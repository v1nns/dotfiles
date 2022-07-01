local M = {}

M.disabled = {
    n = {
        -- disable defaults
        ["<leader>ff"] = {},
        ["<leader>fa"] = {},
        ["<leader>fw"] = {},
        ["<leader>fb"] = {},
        ["<leader>fh"] = {},
        ["<leader>fo"] = {},
        ["<leader>tk"] = {},
        ["<leader>cm"] = {},
        ["<leader>gt"] = {},
        ["<leader>pt"] = {},
    },
}

M.general = {
    n = {
        -- easymotion (for navigation)
        ["<leader>w"] = { "<Plug>(easymotion-bd-w)", "   easymotion word" },

        -- window adjusts
        -- TODO: create function for width based on window position
        ["<C-S-w>"] = { "<cmd> winc > <CR>", "  increase width"},
        ["<C-S-x>"] = { "<cmd> winc < <CR>", "  decrease width"},
        ["<C-S-y>"] = { "<cmd> winc - <CR>", "  increase height"},
        ["<C-S-z>"] = { "<cmd> winc + <CR>", "  decrease height"},
    },
}

M.telescope = {
    n = {
        -- general navigation
        ["<C-S-p>"] = { "<cmd> Telescope commands<CR>", "  show commands" },
        -- ["<?>"] = { "<cmd> Telescope keymaps<CR>", "  show keyboard shortcuts" },
        ["<C-o>"] = { "<cmd> Telescope file_browser quiet=true files=false hidden=true prompt_title=Open\\ folder<CR>", "  open folder" },
        ["<C-p>"] = { "<cmd> Telescope find_files prompt_title=Open\\ file<CR>", "  open file" },
        ["<C-S-b>"] = { "<cmd> Telescope marks<CR>", "  open bookmarks" },
        ["<C-S-f>"] = { "<cmd> Telescope live_grep prompt_title=Search\\ all<CR>", "  search all" },
        ["<A-Tab>"] = { "<cmd> Telescope buffers<CR>", "  find buffers" },

        -- git
        ["<C-g>c"] = { "<cmd> Telescope git_commits <CR>", "  git commits" },
        ["<C-g>t"] = { "<cmd> Telescope git_status <CR>", "  git status" },

        -- lsp
        ["<C-S-o>"] = { "<cmd> Telescope lsp_document_symbols<CR>", "   show lsp symbols" },
    },
}

return M
