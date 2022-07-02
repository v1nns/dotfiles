local M = {
    pre_open = {
        function()
            vim.cmd("SaveSession")
        end,
    },
    post_open = {
        "NvimTreeOpen",
        function(dir)
            local Lib = require("auto-session-library")
            Lib.conf.last_loaded_session = nil
            vim.cmd("RestoreSession")
        end,
    },
}

return M
