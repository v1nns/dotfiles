local M = {}

M.ui = {
    hl_add = require("custom.highlights").add(),

    hl_override = require("custom.highlights").override(),

    -- TODO: move this to another file
    changed_themes = {
        tokyonight = {
            base_16 = {
                base00 = "#1a1b26",
                base01 = "#16161e",
                base02 = "#2f3549",
                base03 = "#444b6a",
                base04 = "#787c99",
                base05 = "#a9b1d6",
                base06 = "#cbccd1",
                base07 = "#d5d6db",
                base08 = "#c0caf5",
                base09 = "#a9b1d6",
                base0A = "#0db9d7",
                base0B = "#9ece6a",
                base0C = "#b4f9f8",
                base0D = "#2ac3de",
                base0E = "#bb9af7",
                base0F = "#f7768e",
            },
        },
    },

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

        -- git diff view
        ["sindrets/diffview.nvim"] = {
            cmd = "DiffviewOpen",
            requires = { "nvim-lua/plenary.nvim" },
            config = function()
                require("diffview").setup({ enhanced_diff_hl = true })
            end,
        },
    },
}

M.mappings = require("custom.mappings")

return M
