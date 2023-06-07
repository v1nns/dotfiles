local M = {}

M.pick_window = function()
    local options = {
        -- hint = "floating-big-letter",
        prompt_message = "",

        selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",

        filter_rules = {
            autoselect_one = true,
            include_current_win = true,

            -- filter using buffer options
            bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = {
                    "neo-tree",
                    "neo-tree-popup",
                    "notify",
                    "quickfix",
                    "nvdash",
                    "*Telescope*",
                },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal" },
            },
        },

        highlights = {
            statusline = {
                focused = {
                    -- fg = "#ededed",
                    fg = "#f9c495",
                    bg = "#e35e4f",
                    bold = true,
                    -- underline = true,
                },
                unfocused = {
                    fg = "#16161e",
                    bg = "#e35e4f",
                    bold = true,
                },
            },
        },
    }

    -- require("window-picker").setup(options)
    return require("window-picker").pick_window(options)
end

return M
