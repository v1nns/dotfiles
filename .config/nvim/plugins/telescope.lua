local M = function()
    return {
        defaults = {
            mappings = {
                n = {
                    ["q"] = require("telescope.actions").close,
                },
            },
        },
        -- builtins
        pickers = {
            find_files = {
                find_command = function()
                    return {
                        "fd",
                        "--type",
                        "f",
                        "--strip-cwd-prefix",
                        "-H",
                        "-E",
                        ".cache",
                        "-E",
                        ".git",
                        "-E",
                        "node_modules",
                        "-E",
                        "build",
                    }
                end,
                no_ignore = true,
                no_ignore_parent = true,
            },
            live_grep = {
                grep_open_files = false,
                additional_args = function()
                    return {
                        "--hidden",
                        "-g",
                        "!.cache/*",
                        "-g",
                        "!.git/*",
                        "-g",
                        "!node_modules/*",
                        "-g",
                        "!build/*",
                    }
                end,
            },
            lsp_document_symbols = {
                mappings = {
                    i = {
                        ["<CR>"] = require("telescope.actions").select_default
                            + require("telescope.actions").center,
                    },
                },
            },
        },
        extensions = {
            file_browser = require("custom.plugins.filebrowser"),
        },
        extensions_list = {
            "themes",
            "terms",
            "file_browser",
        },
    }
end

return M
