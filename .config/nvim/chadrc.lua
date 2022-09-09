local M = {}

local highlights = require("custom.highlights")

M.ui = {
    hl_add = highlights.add(),

    hl_override = highlights.override(),

    changed_themes = highlights.changed_themes(),
    theme = "tokyonight",
}

M.plugins = {
    -- Override default config of a plugin (merging)
    override = {
        -- customize UI from NvChad
        ["NvChad/ui"] = {
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

        ["goolord/alpha-nvim"] = require("custom.plugins.alpha"),
        ["nvim-treesitter/nvim-treesitter"] = require(
            "custom.plugins.treesitter"
        ),
        ["kyazdani42/nvim-tree.lua"] = require("custom.plugins.nvimtree"),
        ["hrsh7th/nvim-cmp"] = require("custom.plugins.cmp"),
        ["lukas-reineke/indent-blankline.nvim"] = require(
            "custom.plugins.blankline"
        ),
        ["nvim-telescope/telescope.nvim"] = require("custom.plugins.telescope"),
        ["lewis6991/gitsigns.nvim"] = require("custom.plugins.gitsigns"),
        ["williamboman/mason.nvim"] = require("custom.plugins.mason"),
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        -- enable greeter screen
        ["goolord/alpha-nvim"] = {
            disable = false,
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

        -- telescope
        ["nvim-telescope/telescope.nvim"] = {
            module = { "telescope", "telescope.actions.state" },
            cmd = { "Telescope", "Telescope file_browser" },
            requires = {
                "nvim-lua/plenary.nvim",
                "nvim-telescope/telescope-file-browser.nvim",
            },
        },

        -- session management
        ["rmagatti/auto-session"] = {
            config = function()
                require("custom.plugins.autosession")
            end,
        },
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

        -- code navigation and highlight
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
        ["unblevable/quick-scope"] = {},

        -- breadcrumbs
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

        -- UI improvement
        ["luukvbaal/stabilize.nvim"] = {},
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

        ["kyazdani42/nvim-tree.lua"] = {
            disable = true,
        },

        ["nvim-neo-tree/neo-tree.nvim"] = {
            branch = "v2.x",
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
    },
}

M.mappings = require("custom.mappings")

return M
