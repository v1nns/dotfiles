local M = {}

local pluginCfg = require "custom.plugins.configs"
local uiCfg = require "custom.ui.configs"
local mappingCfg = require "custom.mappings"

M.ui = {
    hl_override = {
        AlphaHeader = {
           fg = "#c273a2",
        },
        -- AlphaButtons = {
        --     fg = "#ff2233",
        -- },
    },

    theme = "aquarium",

    tabufline = {
        override = uiCfg.tabufline
    }
}

M.plugins = {
    options = {
    --   lspconfig = {
    --      setup_lspconf = "custom.plugins.lspconfig",
    --   },

        statusline = {
            separator_style = "round",
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

        ["nvim-telescope/telescope-file-browser.nvim"] = {}
     },
}

M.mappings = mappingCfg

return M
