local M = {}

M.general = {
   n = {
        ["<C-o>"] = { "<cmd> :Telescope file_browser <CR>", "  open directory" },
   },
}

M.telescope = {
    n = {
        -- find
        ["<C-S-p>"] = { "<cmd> Telescope keymaps <CR>", "  show keys" },
        ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "  find files" },
        ["<C-S-f>"] = { "<cmd> Telescope live_grep <CR>", "  search all" },
        ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },

        -- ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },

        ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "   find oldfiles" },

        -- git
        ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
        ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "  git status" },

         -- pick a hidden term
        ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "   pick hidden term" },

        -- theme switcher
        ["<leader>th"] = { "<cmd> Telescope themes <CR>", "   nvchad themes" },
     },
}

return M