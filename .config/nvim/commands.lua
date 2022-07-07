local M = {}

-- Autocommands
M.setup_autocommands = function()
    local autocmd = vim.api.nvim_create_autocmd

    -- highlight config files
    autocmd(
        { "BufEnter", "BufRead" },
        { pattern = "*conf*", command = "setf dosini" }
    )

    -- set winbar with breadcrumbs and file path
    autocmd({
        "CursorMoved",
        "BufWinEnter",
        "BufFilePost",
        "InsertEnter",
        "BufWritePost",
    }, {
        callback = function()
            require("custom.ui.winbar").setup()
        end,
    })
end

-- Commands
M.setup_commands = function()
    local cmd = vim.api.nvim_create_user_command

    -- remove trailing spaces from current buffer
    cmd("RemoveTrailingSpace", function()
        vim.cmd([[%s/\s\+$//e]])
    end, {})
end

return M
