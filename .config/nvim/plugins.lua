local plugins = {

  -- install treesitter playground
  {
    "nvim-treesitter/playground",
    lazy = false,
    enabled = false
  },

  -- disable default file explorer
  {
    "nvim-tree/nvim-tree.lua",
    disable = true,
  },

  -- instead, use neo-tree as file/buffer/git explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "main",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    cmd = "Neotree",
    opts = function()
      return require("custom.configs.neotree")
    end,
  },

  -- select window to open new buffer
  {
    "s1n7ax/nvim-window-picker",
    opts = function()
      return require("custom.configs.windowpicker")
    end,
  },

  -- syntax highlight for coding
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      return require("custom.configs.treesitter")
    end,
  },

  -- code completion
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require("custom.configs.cmp")
    end,
  },

  -- add indentation guide to code blocks
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function()
      return require("custom.configs.blankline")
    end,
  },

  -- git integration with buffers
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      return require("custom.configs.gitsigns")
    end,
  },

  -- git commit message in a popup
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    -- config = check commands.lua...
  },

  -- git conflict (in a fancy way)
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = true,
  },

  -- portable package manager
  {
    "williamboman/mason.nvim",
    opts = function()
      return require("custom.configs.mason")
    end,
  },

  -- enable keybind window
  {
    "folke/which-key.nvim",
    cmd = "WhichKey",
  },

  -- language server protocol
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("plugins.configs.lspconfig")
      require("custom.configs.lspconfig")
    end,
  },

  -- open directories
  { "nvim-telescope/telescope-file-browser.nvim" },

  -- telescope (ui for pickers: open files, search files, ...)
  {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "Telescope file_browser" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "s1n7ax/nvim-window-picker",
    },
    opts = function()
      return require("custom.configs.telescope")
    end,
  },

  -- session management (1/2)
  {
    "rmagatti/auto-session",
    lazy = false,
    init = function()
      -- set info to be saved with the underlying :mksession
      vim.o.sessionoptions =
      "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
    end,
    opts = function()
      return require("custom.configs.autosession")
    end,
  },
  -- session management (2/2)
  {
    "rmagatti/session-lens",
    cmd = "SearchSession",
    dependencies = {
      "rmagatti/auto-session",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },

  -- code navigation using word-motion
  {
    "phaazon/hop.nvim",
    cmd = {
      "HopAnywhere",
      "HopChar1",
      "HopChar2",
      "HopLine",
      "HopLineStart",
      "HopVertical",
      "HopPattern",
      "HopWord",
    },
    branch = "v2",
    config = true,
  },

  -- fast highlight for unique character in current line
  {
    "unblevable/quick-scope",
    lazy = false,
  },

  -- breadcrumbs using winbar
  {
    "SmiteshP/nvim-navic",
    opts = function()
      return require("custom.configs.navic")
    end,
  },

  -- format and lint
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("custom.configs.null-ls")
    end,
  },

  -- set up a virtual column (similar to a ruler in another IDEs)
  {
    "lukas-reineke/virt-column.nvim",
    lazy = false,
    opts = function()
      return require("custom.configs.virtcolumn")
    end,
  },

  -- code snippets to add documentation based on doxygen
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
        languages = {
          ['cpp.doxygen'] = require('neogen.configurations.cpp')
        },
      })
    end,
  },

  -- surround text selections
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- syntax highlight for log files
  {
    "mtdl9/vim-log-highlighting",
    ft = "log",
    init = function()
    end,
  },

  -- tab navigation
  {
    "nanozuki/tabby.nvim",
    init = function()
      require("custom.ui.tabby").setup()
    end
  },

  -- limit buffers scope per tab
  {
    "tiagovla/scope.nvim",
    init = function()
      require("scope").setup()
    end
  },

  -- -- debug applications
  -- {mfussenegger/nvim-dap",
  -- },
}

return plugins
