local M = {}

local pluginCfg = require "custom.plugins.configs"
local uiCfg = require "custom.ui.configs"
local mappingCfg = require "custom.mappings"

M.options = {
    -- load custom options here
    user = function()
        -- visual column
        vim.opt.colorcolumn = '100'
        -- show trailing spaces and tabs
        vim.opt.list = true
        vim.opt.listchars = { trail = '~', tab = '>>' }
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

    tabufline = {
        override = uiCfg.tabufline
    }

}

M.plugins = {
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.lspconfig",
        },

        statusline = {
            separator_style = "block",
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
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        ["goolord/alpha-nvim"] = {
            disable = false,
        },

        ["nvim-telescope/telescope-file-browser.nvim"] = {},
        -- ["nvim-telescope/telescope-ui-select.nvim"] = {},
        -- ["nvim-telescope/telescope-project.nvim"] = {},
        ["easymotion/vim-easymotion"] = {},

        -- ["stevearc/dressing.nvim"] = {},
        -- ["shatur/neovim-session-manager"] = {},
    },
}

M.mappings = mappingCfg

return M
