local M = {}

M.options = {
    -- load custom options here
    user = function()
        -- enable title
        vim.opt.title = true

        -- show trailing spaces and tabs
        vim.opt.list = true
        vim.opt.listchars = {
            trail = "~", --[[ tab = ">>" ]]
        }

        -- change character for git diff view
        vim.opt.fillchars = { eob = " ", diff = "⣿" }

        -- setup commands
        require("custom.commands").setup_autocommands()
        require("custom.commands").setup_commands()

        -- to debug lspconfig, use this below and :LspLog
        -- vim.lsp.set_log_level("debug")
    end,
}

M.ui = {
    hl_add = {
        -- quickscope highlight colors
        QuickScopePrimary = {
            fg = "#AFFF5F",
        },
        QuickScopeSecondary = {
            fg = "#5FFFFF",
        },
        -- virt-column color
        VirtColumn = {
            fg = "#592929",
        },
    },

    hl_override = {
        AlphaHeader = {
            fg = "#B388FF",
        },
        Comment = {
            fg = "#4CAF50",
        },
        NonText = {
            fg = "#FF2233",
        },
        WinSeparator = {
            fg = "#484852",
        },
    },

    theme = "aquarium",
}

M.plugins = {
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.lspconfig",
        },
    },

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
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        -- enable greeter screen
        ["goolord/alpha-nvim"] = {
            disable = false,
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
        ["easymotion/vim-easymotion"] = {},
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
                require("diffview").setup()
            end,
        },
    },
}

M.mappings = require("custom.mappings")

return M
