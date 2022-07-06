local present, cheatsheet = pcall(require, "cheatsheet")

if not present then
    return
end

local opts = {
    -- For generic cheatsheets like default, unicode, nerd-fonts, etc
    -- bundled_cheatsheets = {
    --     enabled = {},
    --     disabled = {},
    -- },
    bundled_cheatsheets = {
        enabled = { "default", "lua", "markdown", "regex", "nerd-fonts" },
        disabled = { "netrw", "unicode" },
    },

    -- For plugin specific cheatsheets
    -- bundled_plugin_cheatsheets = {
    --     enabled = {},
    --     disabled = {},
    -- }
    bundled_plugin_cheatsheets = false,

    -- For bundled plugin cheatsheets, do not show a sheet if you
    -- don't have the plugin installed (searches runtimepath for
    -- same directory name)
    include_only_installed_plugins = true,

    -- Key mappings bound inside the telescope window
    telescope_mappings = {
        ["<CR>"] = cheatsheet.telescope.actions.select_or_execute,
        ["<A-CR>"] = cheatsheet.telescope.actions.select_or_fill_commandline,
        ["<C-Y>"] = cheatsheet.telescope.actions.copy_cheat_value,
    },
}

cheatsheet.setup(opts)
