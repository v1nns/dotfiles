local options = {
    autoselect_one = true,
    include_current_win = true,
    selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
    filter_rules = {
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = {
                "neo-tree",
                "neo-tree-popup",
                "notify",
                "quickfix",
            },

            -- if the buffer type is one of following, the window will be ignored
            buftype = { "terminal" },
        },
    },
    current_win_hl_color = "#e35e4f",
    other_win_hl_color = "#e35e4f",
}

return options
