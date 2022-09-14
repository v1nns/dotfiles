local M = {}

-- Autocommands
M.setup_autocommands = function()
    local autocmd = vim.api.nvim_create_autocmd

    -- setup title string
    autocmd({ "VimEnter", "DirChanged" }, {
        callback = function()
            -- TODO: show empty when in HOME?
            local cwd = vim.fn.getcwd()
            vim.o.titlestring = vim.fn.fnamemodify(cwd, ":t") .. " - " .. cwd
        end,
    })

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

    -- disable a few features for some filetypes
    autocmd("FileType", {
        pattern = {
            "alpha",
            "packer",
            "*telescope*",
            "terminal",
        },
        callback = function()
            -- disable ruler (aka virtual column)
            require("virt-column").setup_buffer({ virtcolumn = "" })

            -- disable quickscope highlight
            vim.b.qs_local_disable = 1
        end,
    })

    -- close neotree buffer before exitting (otherwise, it is buggy with autosession)
    autocmd({ "VimLeavePre" }, {
        callback = function()
            vim.cmd(":Neotree close")
        end,
    })

    -- sadly, git messenger is configured using global variables,
    -- and that's why this autocmd is necessary
    autocmd("FileType", {
        pattern = { "gitmessengerpopup" },
        callback = function()
            vim.g.git_messenger_always_into_popup = true
            vim.g.git_messenger_floating_win_opts = { border = "single" }
            vim.g.git_messenger_popup_content_margins = false
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

    -- yank current text selection on visual mode
    cmd("SearchForTextSelection", function()
        -- get selected text from visual mode
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg("v")

        -- run live_grep picker from telescope
        -- P.S. lazy loading made me use cmd...
        vim.cmd(
            "Telescope live_grep default_text="
                .. text
                .. " prompt_title=Search\\ all"
        )
    end, {})

    -- close all opened buffers
    cmd("CloseAllBuffers", function()
        local neotree = require("neo-tree.command")
        -- must hide neo-tree before closing all buffers
        neotree.execute({ action = "close" })

        -- close all buffers
        vim.cmd("%bd!")

        -- show neo-tree again (filesystem is default option)
        neotree.execute({ action = "show" })
    end, {})

    -- wrap text at column X (or 100 if no arg is passed)
    -- TODO: implement this for range formatting, read this:
    -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
    cmd("WrapTextAtColumn", function(opts)
        local column = tonumber(opts.args) or 100
        vim.o.textwidth = column
        vim.api.nvim_feedkeys("gwap", "n", false)
    end, { nargs = "?" })
end

return M
