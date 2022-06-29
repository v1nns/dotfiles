local M = {}

local pluginConfs = require "custom.plugins.configs"
local interfaceConfs = require "custom.interface"
local mappingConfs = require "custom.mappings"

M.ui = {
    theme = "aquarium",

    tabufline = {
        override = interfaceConfs.tabufline
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
        ["nvim-treesitter/nvim-treesitter"] = pluginConfs.treesitter,
        ["kyazdani42/nvim-tree.lua"] = pluginConfs.nvimtree,
        ["hrsh7th/nvim-cmp"] = pluginConfs.cmp,
        ["lukas-reineke/indent-blankline.nvim"] = pluginConfs.blankline,
        ["nvim-telescope/telescope.nvim"] = pluginConfs.telescope,
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        ["goolord/alpha-nvim"] = {
            disable = false,
        },

        ["nvim-telescope/telescope-file-browser.nvim"] = {}
     },
}

M.mappings = mappingConfs

return M
