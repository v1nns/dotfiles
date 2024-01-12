local options = {
    -- Options for automatically saving sessions on a timer
    autosave = {
        enabled = false,
        -- How often to save (in seconds)
        interval = 60,
        -- Notify when autosaved
        notify = true,
    },

    -- Save and restore these options
    options = {
        "binary",
        "bufhidden",
        "buflisted",
        "cmdheight",
        "diff",
        "filetype",
        "modifiable",
        "previewwindow",
        "readonly",
        "scrollbind",
        "winfixheight",
        "winfixwidth",
    },

    -- Custom logic for determining if the buffer should be included
    buf_filter = function(bufnr)
        local buftype = vim.bo[bufnr].buftype
        if buftype == "help" then
            return true
        end
        if buftype ~= "" and buftype ~= "acwrite" then
            return false
        end
        if vim.api.nvim_buf_get_name(bufnr) == "" then
            return false
        end

        -- this is required, since the default filter skips nobuflisted buffers
        return true
    end,

    -- The name of the directory to store sessions in
    dir = "session",

    -- Show more detail about the sessions when selecting one to load.
    -- Disable if it causes lag.
    load_detail = true,

    -- List order ["modification_time", "creation_time", "filename"]
    load_order = "modification_time",

    -- Configuration for extensions
    extensions = {
        quickfix = {},
        scope = {},
    },
}

return options
