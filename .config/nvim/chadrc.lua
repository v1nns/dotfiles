local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")
local nvdash = require("custom.ui.nvdash")

M.ui = {
    theme = "tokyonight",
    changed_themes = highlights.changed_themes,

    hl_override = highlights.override,
    hl_add = highlights.add,

    nvdash = {
        load_on_startup = false,
        header = nvdash.header,
        buttons = nvdash.buttons,
    },

    statusline = {
        theme = "vscode_colored",
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
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
