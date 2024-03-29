local M = {}

M.disabled = {
  n = {
    -- disable defaults
    ["<leader>ff"] = {},
    ["<leader>fa"] = {},
    ["<leader>fw"] = {},
    ["<leader>fb"] = {},
    ["<leader>fh"] = {},
    ["<leader>fm"] = {},
    ["<leader>fo"] = {},
    ["<leader>tk"] = {},
    ["<leader>cm"] = {},
    ["<leader>gt"] = {},
    ["<leader>pt"] = {},
    ["<A-h>"] = {},
    ["<C-n>"] = {},
    ["<leader>e"] = {},
    ["<leader>b"] = {},
    ["<leader>x"] = {},
    ["gr"] = {},
  },
}

M.navigation = {
  n = {
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
  },
}

M.buffer = {
  n = {
    ["<C-n>"] = { "<cmd> enew <CR>", "new buffer" },

    ["<Tab>"] = { "<cmd> bnext <CR>", "focus next buffer" },
    ["<S-Tab>"] = { "<cmd> bprev <CR>", "focus previous buffer" },

    ["<leader>x"] = { "<cmd> CloseBuffer <CR>", "close current buffer" },
    ["<C-w>a"] = { "<cmd> CloseAllBuffers <CR>", "close all buffers" },
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

    -- window focus
    ["<C-1>"] = { "<cmd> :1wincmd w <CR>", "focus window 1" },
    ["<C-2>"] = { "<cmd> :2wincmd w <CR>", "focus window 2" },
    ["<C-3>"] = { "<cmd> :3wincmd w <CR>", "focus window 3" },
    ["<C-4>"] = { "<cmd> :4wincmd w <CR>", "focus window 4" },
    ["<C-5>"] = { "<cmd> :5wincmd w <CR>", "focus window 5" },
    ["<C-6>"] = { "<cmd> :6wincmd w <CR>", "focus window 6" },
    ["<C-7>"] = { "<cmd> :7wincmd w <CR>", "focus window 7" },
    ["<C-8>"] = { "<cmd> :8wincmd w <CR>", "focus window 8" },
    ["<C-9>"] = { "<cmd> :9wincmd w <CR>", "focus window 9" },
    ["<C-0>"] = { "<cmd> :0wincmd w <CR>", "focus window 10" },

    -- center focused buffer
    ["<leader>cb"] = {
      "<cmd> ZenMode <CR>",
      "center current buffer",
    },
  },
}

M.tab = {
  n = {
    ["<leader>ta"] = { "<cmd> $tabnew <CR>", "add new tab" },
    ["<leader>tc"] = { "<cmd> tabclose <CR>", "close tab" },
    ["<leader>to"] = {
      "<cmd> tabonly <CR>",
      "close other tabs except current",
    },
    ["<leader>tn"] = { "<cmd> tabn <CR>", "focus next tab" },
    ["<leader>tp"] = { "<cmd> tabp <CR>", "focus previous tab" },

    ["<leader>1"] = { "<cmd> tabn 1 <CR>", "go to tab 1" },
    ["<leader>2"] = { "<cmd> tabn 2 <CR>", "go to tab 2" },
    ["<leader>3"] = { "<cmd> tabn 3 <CR>", "go to tab 3" },
    ["<leader>4"] = { "<cmd> tabn 4 <CR>", "go to tab 4" },
    ["<leader>5"] = { "<cmd> tabn 5 <CR>", "go to tab 5" },
    ["<leader>6"] = { "<cmd> tabn 6 <CR>", "go to tab 6" },
    ["<leader>7"] = { "<cmd> tabn 7 <CR>", "go to tab 7" },
    ["<leader>8"] = { "<cmd> tabn 8 <CR>", "go to tab 8" },
    ["<leader>9"] = { "<cmd> tabn 9 <CR>", "go to tab 9" },
    ["<leader>0"] = { "<cmd> tabn 0 <CR>", "go to tab 0" },
  },
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
        require("nvchad.renamer").open()
      end,
      "rename symbol",
    },

    ["gr"] = {
      "<cmd> TroubleToggle lsp_references<CR>",
      "list all symbol references",
    },

    ["<leader>ld"] = {
      function()
        vim.diagnostic.disable()
      end,
      "disable lsp diagnostics",
    },

    ["<leader>le"] = {
      function()
        vim.diagnostic.enable()
      end,
      "enable lsp diagnostics",
    },

    ["<leader>fm"] = {
      function()
        require("conform").format({ async = true, lsp_fallback = "always" })
      end,
      "format code",
    },
  },

  v = {
    ["<leader>fm"] = { "gq", "format code selection" },
  },
}

M.general = {
  n = {
    -- search utility
    ["n"] = {
      "<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>",
      "repeat last search",
    },

    ["N"] = {
      "<cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>",
      "repeat last search (in opposite direction)",
    },

    ["<leader>fw"] = {
      "<cmd> WrapTextAtColumn <CR>",
      "wrap paragraph",
    },

    ["<A-r>"] = {
      function()
        require("resession").load(nil, { dir = "dirsession" })
      end,
      "recent folders",
    },

    ["<leader>tt"] = {
      "<cmd> Twilight <CR>",
      "toggle code dimming",
    },
  },

  v = {
    ["<leader>fw"] = {
      "<cmd> WrapTextAtColumn <CR>",
      "wrap text selection",
    },
  },
}

M.neotree = {
  n = {
    ["<leader>e"] = {
      "<cmd> Neotree filesystem toggle left <CR>",
      "toggle file tree",
    },
    ["<leader>b"] = {
      "<cmd> Neotree buffers toggle left <CR>",
      "toggle buffer tree",
    },
    -- ["<leader>g"] = {
    --     "<cmd>Neotree git_status toggle left <CR>",
    --     "toggle git status tree",
    -- },
    ["<leader>g"] = {
      function()
        local lib = require("diffview.lib")
        local view = lib.get_current_view()
        if view then
          -- Current tabpage is a Diffview; close it
          vim.cmd(":DiffviewClose")
        else
          -- No open Diffview exists: open a new one
          vim.cmd(":DiffviewOpen")
        end
      end,
      "toggle git diff view",
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
      "<cmd> Telescope find_files prompt_title=Open\\ file<CR>",
      "open file",
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
  n = {
    ["<A-y>"] = {
      "<cmd> InsertCommentDivider <CR>",
      "add divider line",
    },
  },

  i = {
    ["<A-y>"] = {
      "<ESC><cmd> InsertCommentDivider <CR>",
      "add divider line",
    },
  },

  v = {
    ["gc"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },

    ["<A-y>"] = {
      "<cmd> InsertCommentDivider <CR>",
      "add divider line",
    },
  },
}

return M
