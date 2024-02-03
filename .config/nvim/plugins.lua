local plugins = {

    -- install treesitter playground
    {
        "nvim-treesitter/playground",
        lazy = false,
        enabled = false,
    },

    -- replace UI for messages, cmdline and the popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = require("custom.configs.noice"),
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },

    -- disable default file explorer
    {
        "nvim-tree/nvim-tree.lua",
        enabled = false,
    },

    -- instead, use neo-tree as file/buffer/git explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
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
        name = "window-picker",
        event = "VeryLazy",
        version = "2.*",
        config = function()
            require("window-picker").setup()
        end,
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

    -- git integration with buffers
    {
        "lewis6991/gitsigns.nvim",
        -- override init from nvchad
        init = function()
            require("core.utils").lazy_load("gitsigns.nvim")
        end,
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
        lazy = false,
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.configs.lspconfig")
        end,
    },

    -- code formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            local opts =require("custom.configs.conform")
            require("conform").setup(opts)

             -- Set formatexpr
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
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

    -- session management + limit buffers scope per tab
    {
        "stevearc/resession.nvim",
        lazy = false,
        dependencies = {
            {
                "tiagovla/scope.nvim",
                lazy = false,
                config = true,
            },
        },
        opts = function()
            return require("custom.configs.resession")
        end,
    },

    -- breadcrumbs using winbar
    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            dofile(vim.g.base46_cache .. "navic") -- load its hl groups cache!
            local opts = require("custom.configs.navic")

            require("nvim-navic").setup(opts)
        end,
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
        keys = { "<C-d>", "<C-u>" },
        config = function()
            require("custom.configs.neoscroll").setup()
        end,
    },

    -- word motion using search
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    -- default options: exact mode, multi window, all directions, with a backdrop
                    require("flash").jump()
                end,
                desc = "Flash",
            },
        },
    },

    -- scrollbar
    {
        "dstein64/nvim-scrollview",
        lazy = false,
        init = function()
            require("scrollview").setup()
        end,
    },

    -- highlight TODO comments
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },

    -- dim unfocused code
    {
        "folke/twilight.nvim",
        cmd = "Twilight",
        opts = {},
    },

    -- zen mode (center current buffer)
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        opts = {
            plugins = {
                options = {
                    enabled = true,
                },
                twilight = {
                    enabled = true,
                },
            },
        },
    },

    -- line motion using marks
    {
        "chentoast/marks.nvim",
        init = function()
            require("marks").setup()
        end,
    },

    -- -- debug applications
    -- {mfussenegger/nvim-dap",
    -- },
}

return plugins
