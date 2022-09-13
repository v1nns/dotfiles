local M = {}

local highlights = require("custom.highlights")

M.ui = {
    hl_add = highlights.add(),

    hl_override = highlights.override(),

    changed_themes = highlights.changed_themes(),
    theme = "tokyonight",
}

M.plugins = {

    -- customize UI from NvChad
    ["NvChad/ui"] = {
        override_options = {
            statusline = {
                separator_style = "block",
                overriden_modules = function()
                    return require("custom.ui.statusline")
                end,
            },
            tabufline = {
                enabled = false,
                overriden_modules = function()
                    return require("custom.ui.tabufline")
                end,
            },
        },
    },

    -- enable greeter screen
    ["goolord/alpha-nvim"] = {
        disable = false,
        override_options = require("custom.plugins.alpha"),
    },

    -- disable default file explorer
    ["kyazdani42/nvim-tree.lua"] = {
        disable = true,
        override_options = require("custom.plugins.nvimtree"),
    },

    -- instead, use neo-tree as file/buffer/git explorer
    ["nvim-neo-tree/neo-tree.nvim"] = {
        branch = "main",
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        module = "neo-tree",
        cmd = "Neotree",
        config = function()
            require("custom.plugins.neotree")
        end,
    },

    -- syntax highlight for coding
    ["nvim-treesitter/nvim-treesitter"] = {
        override_options = require("custom.plugins.treesitter"),
    },

    -- code completion
    ["hrsh7th/nvim-cmp"] = { override_options = require("custom.plugins.cmp") },

    -- add indentation guide to code blocks
    ["lukas-reineke/indent-blankline.nvim"] = {
        override_options = require("custom.plugins.blankline"),
    },

    -- git integration with buffers
    ["lewis6991/gitsigns.nvim"] = {
        override_options = require("custom.plugins.gitsigns"),
    },

    -- portable package manager
    ["williamboman/mason.nvim"] = {
        override_options = require("custom.plugins.mason"),
    },

    -- enable keybind window
    ["folke/which-key.nvim"] = { disable = false },

    -- language server protocol
    ["neovim/nvim-lspconfig"] = {
        config = function()
            require("plugins.configs.lspconfig")
            require("custom.plugins.lspconfig")
        end,
    },

    -- open directories
    ["nvim-telescope/telescope-file-browser.nvim"] = {},

    -- telescope (ui for pickers: open files, search files, ...)
    ["nvim-telescope/telescope.nvim"] = {
        module = { "telescope", "telescope.actions.state" },
        cmd = { "Telescope", "Telescope file_browser" },
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        override_options = require("custom.plugins.telescope"),
    },

    -- session management (1/2)
    ["rmagatti/auto-session"] = {
        config = function()
            require("custom.plugins.autosession")
        end,
    },
    -- session management (2/2)
    ["rmagatti/session-lens"] = {
        cmd = "SearchSession",
        requires = {
            "rmagatti/auto-session",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("session-lens").setup()
        end,
    },

    -- code navigation using word-motion
    ["phaazon/hop.nvim"] = {
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
        config = function()
            require("hop").setup()
        end,
    },

    -- fast highlight for unique character in current line
    ["unblevable/quick-scope"] = {},

    -- breadcrumbs using winbar
    ["SmiteshP/nvim-navic"] = {
        config = function()
            require("custom.plugins.navic")
        end,
    },

    -- format and lint
    ["jose-elias-alvarez/null-ls.nvim"] = {
        after = "nvim-lspconfig",
        config = function()
            require("custom.plugins.null-ls")
        end,
    },

    -- stabilize buffer content on window open/close events
    ["luukvbaal/stabilize.nvim"] = {},

    -- set up a virtual column (similar to a ruler in another IDEs)
    ["lukas-reineke/virt-column.nvim"] = {
        module = "virt-column",
        config = function()
            require("custom.plugins.virtcolumn")
        end,
    },

    -- code snippets to add documentation based on doxygen
    ["danymat/neogen"] = {
        cmd = "Neogen",
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
    },

    -- surround text selections
    ["kylechui/nvim-surround"] = {
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- -- debug applications
    -- ["mfussenegger/nvim-dap"] = {
    -- },
}

M.mappings = require("custom.mappings")

return M
