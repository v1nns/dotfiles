local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")
local nvdash = require("custom.ui.nvdash")

M.ui = {
    theme = "tokyonight",
    changed_themes = highlights.changed_themes,
    lsp_semantic_tokens = true,

    hl_override = highlights.override,
    hl_add = highlights.add,

    nvdash = {
        load_on_startup = false,
        header = nvdash.header,
        buttons = nvdash.buttons,
    },

    -- will include navic's base46 hlgroup cache in base46's auto-compile functionality
    extended_integrations = { "navic" },

    statusline = {
        theme = "vscode_colored",
    },

    tabufline = {
        enabled = false,
        overriden_modules = function()
            return require("custom.ui.tabufline")
        end,
    },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
