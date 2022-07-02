local M = {}

local pluginCfg = require("custom.plugins.configs")
local uiCfg = require("custom.ui.configs")
local mappingCfg = require("custom.mappings")

M.options = {
    -- load custom options here
    user = function()
        -- visual column
        vim.opt.colorcolumn = "100"
        -- show trailing spaces and tabs
        vim.opt.list = true
        vim.opt.listchars = { trail = "~", tab = ">>" }
        -- setup formatters
        vim.g.neoformat_lua_stylua = { exe = "stylua" }
        vim.g.neoformat_enabled_lua = { "autopep8" }
    end,
}

M.ui = {
    hl_override = {
        AlphaHeader = {
            fg = "#B388FF",
        },
        -- AlphaButtons = {
        --     fg = "#FF2233",
        -- },
        ColorColumn = {
            bg = "#C34864",
        },
        Comment = {
            fg = "#4CAF50",
        },
        NonText = {
            fg = "#FF2233",
        },
    },

    theme = "aquarium",

    statusline = {
        separator_style = "block",
        override = {
            fileInfo = uiCfg.statusline_fileinfo,
            cursor_position = uiCfg.statusline_cursorposition,
        },
    },

    tabufline = {
        override = uiCfg.tabufline,
    },
}

M.plugins = {
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.lspconfig",
        },
    },

    -- Override default config of a plugin (merging)
    override = {
        ["goolord/alpha-nvim"] = pluginCfg.alpha,
        ["nvim-treesitter/nvim-treesitter"] = pluginCfg.treesitter,
        ["kyazdani42/nvim-tree.lua"] = pluginCfg.nvimtree,
        ["hrsh7th/nvim-cmp"] = pluginCfg.cmp,
        ["lukas-reineke/indent-blankline.nvim"] = pluginCfg.blankline,
        ["nvim-telescope/telescope.nvim"] = pluginCfg.telescope,
        ["lewis6991/gitsigns.nvim"] = pluginCfg.gitsigns,
        ["willthbill/opener.nvim"] = pluginCfg.opener,
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        -- enable greeter screen
        ["goolord/alpha-nvim"] = {
            disable = false,
        },

        -- open directories and session management
        ["willthbill/opener.nvim"] = {},
        ["rmagatti/auto-session"] = {},

        -- ["nvim-telescope/telescope-file-browser.nvim"] = {},
        -- ["nvim-telescope/telescope-ui-select.nvim"] = {},
        -- ["nvim-telescope/telescope-project.nvim"] = {},
        -- ["shatur/neovim-session-manager"] = {},

        -- code navigation and highlight
        ["easymotion/vim-easymotion"] = {},
        ["RRethy/vim-illuminate"] = {},

        -- format and lint
        ["jose-elias-alvarez/null-ls.nvim"] = {
            after = "nvim-lspconfig",
            config = function()
                require("custom.plugins.null-ls").setup()
            end,
        },
    },
}

M.mappings = mappingCfg

return M
