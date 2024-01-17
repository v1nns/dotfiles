local M = {}

M.pick_window = function()
    -- Check if got enough windows to select, otherwise do not execute window-picker extension
    local all_windows = vim.api.nvim_tabpage_list_wins(0)
    local count = 0
    for _ in pairs(all_windows) do
        count = count + 1
    end

    if count <= 1 then
        return false
    end

    local options = {
        hint = "floating-big-letter",
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
                buftype = { "terminal", "nofile" },
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

    local window_id = require("window-picker").pick_window(options)

    if window_id then
        vim.api.nvim_set_current_win(window_id)
    end

    return true
end

return M
