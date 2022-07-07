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
        ["<M-h>"] = {},
    },
}

M.general = {
    n = {
        -- for navigation
        ["<leader>w"] = { "<Plug>(easymotion-bd-w)", "   easymotion word" },
        ["<M-j>"] = { "5j", "move lines 5x downwards" },
        ["<M-k>"] = { "5k", "move lines 5x upwards" },
        ["<M-h>"] = { "b", "move back a word" },
        ["<M-l>"] = { "w", "move forward a word" },

        -- window adjusts
        -- TODO: create function for width based on window position
        ["<C-S-w>"] = { "<cmd> winc > <CR>", "  increase width" },
        ["<C-S-x>"] = { "<cmd> winc < <CR>", "  decrease width" },
        ["<C-S-y>"] = { "<cmd> winc - <CR>", "  increase height" },
        ["<C-S-z>"] = { "<cmd> winc + <CR>", "  decrease height" },

        -- move lines
        ["<M-Down>"] = { "<cmd> :m .+1<CR>==", "  move line upwards" },
        ["<M-Up>"] = { "<cmd> :m .-2<CR>==", "  move line downwards" },

        -- git
        ["<C-g>b"] = {
            "<cmd> Gitsigns toggle_current_line_blame<CR>",
            "  toggle git blame",
        },

        -- rename
        ["<F2>"] = {
            '<cmd>lua require("nvchad.ui.renamer").open()<CR>',
            "凜 rename object",
        },
    },
}

M.telescope = {
    n = {
        -- general navigation
        ["<C-S-p>"] = { "<cmd> Cheatsheet<CR>", "  show commands" },
        -- ["<?>"] = { "<cmd> Telescope keymaps<CR>", "  show keyboard shortcuts" },
        ["<C-o>"] = {
            "<cmd> Telescope file_browser path=~ prompt_title=Open\\ folder<CR>",
            "  open folder",
        },
        ["<C-p>"] = {
            "<cmd> Telescope find_files hidden=true prompt_title=Open\\ file<CR>",
            "  open file",
        },
        ["<C-S-b>"] = { "<cmd> Telescope marks<CR>", "  open bookmarks" },
        ["<C-S-f>"] = {
            "<cmd> Telescope live_grep prompt_title=Search\\ all<CR>",
            "  search all",
        },
        ["<A-Tab>"] = { "<cmd> Telescope buffers<CR>", "  find buffers" },

        -- git
        ["<C-g>c"] = {
            "<cmd> Telescope git_commits <CR>",
            "  git commits",
        },
        ["<C-g>t"] = { "<cmd> Telescope git_status <CR>", "  git status" },

        -- lsp
        ["<C-S-o>"] = {
            "<cmd> Telescope lsp_document_symbols<CR>",
            "  show lsp symbols",
        },
    },
}

return M
