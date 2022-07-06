local M = function()
    return {
        defaults = {
            mappings = {
                n = {
                    ["q"] = require("telescope.actions").close,
                },
            },
        },
        pickers = {
            find_files = {
                find_command = {
                    "fd",
                    "--type",
                    "f",
                    "--strip-cwd-prefix",
                    "-H",
                    "-E",
                    ".git",
                    "-E",
                    "node_modules",
                },
                -- file_ignore_patterns = { ".git", "node_modules" },
            },
            live_grep = {
                grep_open_files = false,
                additional_args = function()
                    return {
                        "--hidden",
                        "-g",
                        "!.git/*",
                        "-g",
                        "!node_modules/*",
                    }
                end,
            },
        },
        extensions = {
            file_browser = require("custom.plugins.filebrowser"),
        },
        extensions_list = { "themes", "terms", "file_browser" },
    }
end

return M
