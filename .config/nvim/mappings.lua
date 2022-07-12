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
        ["<A-h>"] = {},
    },
}

M.general = {
    n = {
        -- for navigation
        ["<leader>w"] = { "<Plug>(easymotion-bd-w)", "   easymotion word" },
        ["<A-j>"] = { "5j", "move lines 5x downwards" },
        ["<A-k>"] = { "5k", "move lines 5x upwards" },
        ["<A-h>"] = { "b", "move back a word" },
        ["<A-l>"] = { "w", "move forward a word" },

        -- jumplist
        ["<A-Left>"] = { "<C-O>zz", "move back" },
        ["<A-Right>"] = { "<C-I>zz", "move forward" },

        -- window adjusts
        -- TODO: create function for width based on window position
        ["<C-S-w>"] = { "<cmd> winc > <CR>", "  increase width" },
        ["<C-S-x>"] = { "<cmd> winc < <CR>", "  decrease width" },
        ["<C-S-y>"] = { "<cmd> winc - <CR>", "  increase height" },
        ["<C-S-z>"] = { "<cmd> winc + <CR>", "  decrease height" },

        -- move lines
        ["<A-Down>"] = { "<cmd> :m .+1<CR>==", "  move line upwards" },
        ["<A-Up>"] = { "<cmd> :m .-2<CR>==", "  move line downwards" },

        -- git
        ["<C-g>b"] = {
            "<cmd> Gitsigns toggle_current_line_blame<CR>",
            "  toggle git blame",
        },
        ["<C-g>s"] = {
            "<cmd> Gitsigns preview_hunk<CR>",
            "  show current hunk",
        },
        ["<C-g>p"] = {
            "<cmd> Gitsigns prev_hunk<CR>",
            "  go to previous hunk",
        },
        ["<C-g>n"] = {
            "<cmd> Gitsigns next_hunk<CR>",
            "  go to next hunk",
        },
        ["<C-g>u"] = {
            "<cmd> Gitsigns reset_hunk<CR>",
            "  undo current hunk",
        },

        -- rename
        ["<F2>"] = {
            '<cmd>lua require("nvchad.ui.renamer").open()<CR>',
            "凜  rename object",
        },
    },
}

M.telescope = {
    n = {
        -- general navigation
        ["<C-S-p>"] = { "<cmd> Cheatsheet<CR>", "  show commands" },
        -- ["<?>"] = { "<cmd> Telescope keymaps<CR>", "  show keyboard shortcuts" },
        ["<A-o>"] = {
            "<cmd> Telescope file_browser path=$HOME prompt_title=Open\\ folder<CR>",
            "  open folder",
        },
        ["<A-p>"] = {
            "<cmd> Telescope find_files hidden=true prompt_title=Open\\ file<CR>",
            "  open file",
        },
        ["<A-r>"] = {
            "<cmd> SearchSession<CR>",
            "  recent folders",
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

    v = {
        ["<C-S-f>"] = {
            "<cmd> SearchForTextSelection<CR>",
            "  search all",
        },
    },
}

return M
