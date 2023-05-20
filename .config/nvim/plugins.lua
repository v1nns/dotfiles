local plugins = {

    -- install treesitter playground
    {
        "nvim-treesitter/playground",
        lazy = false,
        enabled = true,
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
        opts = require("custom.configs.neotree"),
    },

    -- select window to open new buffer
    {
        "s1n7ax/nvim-window-picker",
        opts = require("custom.configs.windowpicker"),
    },

    -- syntax highlight for coding
    {
        "nvim-treesitter/nvim-treesitter",
        opts = require("custom.configs.treesitter"),
    },

    -- code completion
    {
        "hrsh7th/nvim-cmp",
        opts = require("custom.configs.cmp"),
    },

    -- add indentation guide to code blocks
    {
        "lukas-reineke/indent-blankline.nvim",
        opts = require("custom.configs.blankline"),
    },

    -- git integration with buffers
    {
        "lewis6991/gitsigns.nvim",
        opts = require("custom.configs.gitsigns"),
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

    -- git diff in a separate view
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = require("custom.configs.diffview"),
    },

    -- portable package manager
    {
        "williamboman/mason.nvim",
        opts = require("custom.configs.mason"),
    },

    -- language server protocol
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                -- format and lint
                require("custom.configs.null-ls")
            end,
        },
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
        opts = require("custom.configs.autosession"),
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
        "jinh0/eyeliner.nvim",
        lazy = false,
        init = function()
            require("eyeliner").setup({
                highlight_on_key = true,
                dim = true,
            })
        end,
    },

    -- breadcrumbs using winbar
    {
        "SmiteshP/nvim-navic",
        opts = require("custom.configs.navic"),
    },

    -- set up a virtual column (similar to a ruler in another IDEs)
    {
        "lukas-reineke/virt-column.nvim",
        lazy = false,
        opts = require("custom.configs.virtcolumn"),
    },

    -- code snippets to add documentation based on doxygen
    {
        "danymat/neogen",
        cmd = "Neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        init = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
                languages = {
                    ["cpp.doxygen"] = require("neogen.configurations.cpp"),
                },
            })
        end,
    },

    -- surround text selections
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability
        event = "VeryLazy",
        init = function()
            require("nvim-surround").setup()
        end,
    },

    -- syntax highlight for log files
    {
        "mtdl9/vim-log-highlighting",
        ft = "log",
        init = function() end,
    },

    -- tab navigation
    {
        "nanozuki/tabby.nvim",
        init = function()
            require("custom.ui.tabby").setup()
        end,
    },

    -- limit buffers scope per tab
    {
        "tiagovla/scope.nvim",
        init = function()
            require("scope").setup()
        end,
    },

    -- enhance search command
    {
        "kevinhwang91/nvim-hlslens",
        keys = { "/", "?", "n", "N" },
        init = function()
            require("hlslens").setup()
        end,
    },

    -- enhance code diagnostics
    {
        "folke/trouble.nvim",
        dependencies = "nvim-tree/nvim-web-devicons",
        cmd = "Trouble",
        init = function()
            require("trouble").setup()
        end,
    },

    -- smooth scrolling
    {
        "karb94/neoscroll.nvim",
        init = function()
            require("neoscroll").setup()
        end,
    },

    -- -- debug applications
    -- {mfussenegger/nvim-dap",
    -- },
}

return plugins
