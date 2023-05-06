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
    ["<C-n>"] = {},
    ["<leader>e"] = {},
    ["<leader>b"] = {},
    ["gr"] = {},
  },
}

M.navigation = {
  n = {
    ["j"] = { "gj", "move line downwards (even with word-wrap)" },
    ["k"] = { "gk", "move line upwards (even with word-wrap)" },
    ["<leader>w"] = { "<cmd> HopWord <CR>", "word motion" },
    ["<A-j>"] = { "5gj", "move lines 5x downwards" },
    ["<A-k>"] = { "5gk", "move lines 5x upwards" },
    ["<A-h>"] = { "b", "move back a word" },
    ["<A-l>"] = { "w", "move forward a word" },

    -- jumplist
    ["<A-Left>"] = { "<C-O>zz", "move back" },
    ["<A-Right>"] = { "<C-I>zz", "move forward" },
    -- ["<A-h>"] = { "<C-O>zz", "move back" },
    -- ["<A-l"] = { "<C-I>zz", "move forward" },

    -- move lines
    ["<A-Down>"] = { "<cmd> :m .+1<CR>==", "move line upwards" },
    ["<A-Up>"] = { "<cmd> :m .-2<CR>==", "move line downwards" },
  },

  i = {
    -- delete previous word
    ["<C-BS>"] = {
      "<C-W>",
      "delete previous word",
    },
  }
}

M.buffer = {
  n = {
    ["<C-n>"] = { "<cmd> enew <CR>", "new buffer" },

    ["<Tab>"] = {
      "<cmd> GoToNext <CR>",
      "focus next buffer",
    },
    ["<S-Tab>"] = {
      "<cmd> GoToPrev <CR>",
      "focus previous buffer",
    },
    ["<leader>x"] = {
      "<cmd> CloseCurrentBuffer <CR>",
      "close current buffer",
    },
    ["<C-w>a"] = {
      "<cmd> CloseAllBuffers <CR>",
      "close all buffers",
    },
  },
}

M.window = {
  n = {
    -- window adjusts (for kitty)
    -- TODO: create function for width based on window position
    ["<C-S-w>"] = { "<cmd> winc > <CR>", "increase width" },
    ["<C-S-x>"] = { "<cmd> winc < <CR>", "decrease width" },
    ["<C-S-y>"] = { "<cmd> winc - <CR>", "increase height" },
    ["<C-S-z>"] = { "<cmd> winc + <CR>", "decrease height" },

    -- window adjusts (for neovim-qt)
    -- TODO: create function for width based on window position
    ["<C-S-Right>"] = { "<cmd> winc > <CR>", "increase width" },
    ["<C-S-Left>"] = { "<cmd> winc < <CR>", "decrease width" },
    ["<C-S-Up>"] = { "<cmd> winc - <CR>", "increase height" },
    ["<C-S-Down>"] = { "<cmd> winc + <CR>", "decrease height" },

  },
}

M.tab = {
  n = {
    ["<leader>ta"] = {
      "<cmd> $tabnew <CR>",
      "add new tab",
    },
    ["<leader>tc"] = {
      "<cmd> tabclose <CR>",
      "close tab",
    },
    ["<leader>to"] = {
      "<cmd> tabonly <CR>",
      "close other tabs except current",
    },
    ["<leader>tn"] = {
      "<cmd> tabn <CR>",
      "focus next tab",
    },
    ["<leader>tp"] = {
      "<cmd> tabp <CR>",
      "focus previous tab",
    },
  }
}

M.git = {
  n = {
    ["<C-g>b"] = {
      "<cmd> Gitsigns toggle_current_line_blame<CR>",
      "toggle git blame",
    },
    ["<C-g>s"] = {
      "<cmd> Gitsigns preview_hunk<CR>",
      "show current hunk",
    },
    ["<C-g>p"] = {
      "<cmd> Gitsigns prev_hunk<CR>",
      "go to previous hunk",
    },
    ["<C-g>n"] = {
      "<cmd> Gitsigns next_hunk<CR>",
      "go to next hunk",
    },
    ["<C-g>u"] = {
      "<cmd> Gitsigns reset_hunk<CR>",
      "undo current hunk",
    },
    ["<C-g>a"] = {
      "<cmd> Gitsigns stage_hunk<CR>",
      "stage current hunk",
    },
    ["<C-g>r"] = {
      "<cmd> Gitsigns undo_stage_hunk<CR>",
      "unstage current hunk",
    },
    ["<C-g>d"] = {
      "<cmd> Gitsigns diffthis <CR>",
      "show git diff on current buffer",
    },
    ["<C-g>m"] = {
      "<cmd> GitMessenger <CR>",
      "show commit message from current line",
    },
  },
}

M.lspconfig = {
  n = {
    ["<F2>"] = {
      function()
        -- TODO: create my own renamer without showing curr_name
        require("nvchad_ui.renamer").open()
      end,
      "rename symbol",
    },

    ["gr"] = {
      "<cmd> TroubleToggle lsp_references<CR>",
      "list all symbol references",
    },
  },
}

M.general = {
  n = {
    -- search utility
    ["n"] = {
      "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>",
    },

    ["N"] = {
      "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
    },
  },
}

M.neotree = {
  n = {
    ["<leader>e"] = {
      "<cmd>Neotree filesystem toggle left <CR>",
      "toggle file tree",
    },
    ["<leader>b"] = {
      "<cmd>Neotree buffers toggle left <CR>",
      "toggle buffer tree",
    },
    ["<leader>g"] = {
      "<cmd>Neotree git_status toggle left <CR>",
      "toggle git status tree",
    },
  },
}

M.telescope = {
  n = {
    -- general navigation
    ["<A-o>"] = {
      "<cmd> Telescope file_browser path=$HOME prompt_title=Open\\ folder<CR>",
      "open folder",
    },
    ["<A-p>"] = {
      "<cmd> Telescope find_files hidden=true prompt_title=Open\\ file<CR>",
      "open file",
    },
    ["<A-r>"] = {
      "<cmd> SearchSession<CR>",
      "recent folders",
    },

    ["<C-S-b>"] = { "<cmd> Telescope marks<CR>", "open bookmarks" },
    ["<C-S-f>"] = {
      "<cmd> Telescope live_grep prompt_title=Search\\ all<CR>",
      "search all",
    },
    ["<leader><Tab>"] = { "<cmd> Telescope buffers<CR>", "find buffers" },

    -- git
    ["<C-g>c"] = {
      "<cmd> Telescope git_commits <CR>",
      "git commits",
    },
    ["<C-g>t"] = { "<cmd> Telescope git_status <CR>", "git status" },

    -- lsp
    ["<C-S-o>"] = {
      "<cmd> Telescope lsp_document_symbols <CR>",
      "show lsp symbols",
    },
  },

  v = {
    ["<C-S-f>"] = {
      "<cmd> SearchForTextSelection <CR>",
      "search all",
    },
  },
}

M.comment = {
  v = {
    ["gc"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

return M
