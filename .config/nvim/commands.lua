local M = {}

-- Autocommands
M.setup_autocommands = function()
    local autocmd = vim.api.nvim_create_autocmd

    -- automatic commands to execute when neovim is opened
    autocmd({ "VimEnter", "DirChanged" }, {
        callback = function()
            -- setup title string
            -- TODO: show empty when in HOME?
            local cwd = vim.fn.getcwd()
            vim.o.titlestring = vim.fn.fnamemodify(cwd, ":t") .. " - " .. cwd

            -- force highlights reload
            require("base46").load_all_highlights()
        end,
    })

    -- auto load session when neovim is opened
    autocmd({ "VimEnter" }, {
        callback = function()
            -- only load the session if nvim was started with no args
            if vim.fn.argc(-1) == 0 then
                local resession = require("resession")

                -- Save these to a different directory, so our manual sessions don't get polluted
                resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end

            -- enable treesitter-based folding
            vim.cmd("set foldmethod=expr")
            vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
            vim.cmd("set nofoldenable")
        end,
    })

    -- close some stuff before exitting and save a session
    autocmd({ "VimLeavePre" }, {
        callback = function()
            vim.cmd(":DiffviewClose")
            vim.cmd(":tabdo Neotree close")

            -- do not save session if current buffer is a gitcommit
            if vim.bo.filetype == "gitcommit" then
                return
            end

            -- exclude some paths to avoid saving any session
            if vim.fn.getcwd() ~= vim.env.HOME and string.find(vim.fn.getcwd(), "/tmp/") == nil then
                -- save session
                require("resession").save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
            end
        end,
    })

    -- preserve equal size for splitted windows after resize
    autocmd({ "VimResized" }, {
        command = "wincmd =",
    })

    -- open nvdash on startup
    autocmd({ "UIEnter" }, {
        callback = function()
            M.show_dashboard()
        end,
    })

    -- open nvdash after deleted all buffers (requires bufdelete.nvim)
    autocmd("User", {
        pattern = "BDeletePost*",
        callback = function()
            M.show_dashboard()
        end,
    })

    -- highlight config files
    autocmd({ "BufEnter", "BufRead" }, { pattern = "*.*conf*", command = "setf dosini" })

    -- highlight rofi theme files
    autocmd({ "BufEnter", "BufRead" }, { pattern = "*.rasi", command = "setf css" })

    -- highlight c++ files
    -- autocmd(
    --     { "BufEnter", "BufRead" },
    --     { pattern = { "*.cc", "*.h", "*.cpp" }, command = "setf cpp" }
    -- )

    -- auto-wrap comments, don't auto insert comment on o/O and enter
    autocmd("FileType", {
        command = "set formatoptions-=cro",
    })

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

    -- enable line number in telescope previewer
    autocmd("User", { pattern = "TelescopePreviewerLoaded", command = "setlocal number" })

    -- disable a few features for some filetypes
    autocmd("FileType", {
        pattern = {
            "nvdash",
            "nvcheatsheet",
            "packer",
            "*Telescope*",
            "terminal",
            "mason",
            "Trouble",
        },
        callback = function()
            -- disable ruler (aka virtual column)
            require("virt-column").setup_buffer({ virtcolumn = "" })

            -- disable quickscope highlight
            vim.b.qs_local_disable = 1
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

    -- monitor all buffers to include into vim.t.bufs
    autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
        callback = function(args)
            if vim.t.bufs == nil then
                vim.t.bufs = vim.api.nvim_get_current_buf() == args.buf and {} or { args.buf }
            else
                local bufs = vim.t.bufs

                -- check for duplicates
                if
                    not vim.tbl_contains(bufs, args.buf)
                    and (args.event == "BufEnter" or vim.bo[args.buf].buflisted)
                    and (args.event == "BufEnter" or args.buf ~= vim.api.nvim_get_current_buf())
                    and vim.api.nvim_buf_is_valid(args.buf)
                    and vim.bo[args.buf].buflisted
                then
                    table.insert(bufs, args.buf)

                    -- remove unnamed buffer which isnt current buf & modified
                    for index, bufnr in ipairs(bufs) do
                        if
                            #vim.api.nvim_buf_get_name(bufnr) == 0
                            and (vim.api.nvim_get_current_buf() ~= bufnr or bufs[index + 1])
                            and not vim.api.nvim_buf_get_option(bufnr, "modified")
                        then
                            table.remove(bufs, index)
                        end
                    end

                    vim.t.bufs = bufs
                end
            end
        end,
    })

    -- monitor all buffer deletions to remove from vim.t.bufs
    autocmd("BufDelete", {
        callback = function(args)
            for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
                local bufs = vim.t[tab].bufs
                if bufs then
                    for i, bufnr in ipairs(bufs) do
                        if bufnr == args.buf then
                            table.remove(bufs, i)
                            vim.t[tab].bufs = bufs
                            break
                        end
                    end
                end
            end
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
        require("telescope.builtin").live_grep({
            prompt_title = "Search all",
            default_text = text,
        })
    end, {})

    -- close all opened buffers
    cmd("CloseAllBuffers", function()
        local neotree = require("neo-tree.command")
        -- must hide neo-tree before closing all buffers
        neotree.execute({ action = "close" })

        -- close all buffers
        -- TODO: close all windows in tab, instead of everything
        local count = 0
        for _, _ in ipairs(vim.api.nvim_list_tabpages()) do
            count = count + 1
        end

        if count == 1 then
            vim.cmd("%bd")
        else
            vim.cmd(":windo bd")
        end

        -- show neo-tree again (filesystem is default option)
        -- neotree.execute({ action = "show" })
    end, {})

    -- wrap text at column X (or value is asked)
    cmd("WrapTextAtColumn", function(opts)
        local column = tonumber(opts.args) or tonumber(vim.fn.input("Column to wrap: "))
        if column == nil then
            return
        end

        -- set maximum text width
        vim.o.textwidth = column

        -- based on current mode, use different motion to apply word wrap
        local mode = vim.fn.mode()
        if mode == "n" then
            vim.api.nvim_feedkeys("gwap", "n", false)
        elseif mode == "v" then
            vim.api.nvim_feedkeys("gq", "v", false)
        end
    end, { nargs = "?" })

    -- go to next open buffer
    cmd("GoToNext", function()
        local bufs = M.bufilter() or {}

        for i, v in ipairs(bufs) do
            if vim.api.nvim_get_current_buf() == v then
                vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
                break
            end
        end
    end, {})

    -- go to previous open buffer
    cmd("GoToPrev", function()
        local bufs = M.bufilter() or {}

        for i, v in ipairs(bufs) do
            if vim.api.nvim_get_current_buf() == v then
                vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
                break
            end
        end
    end, {})

    -- close current buffer
    cmd("CloseCurrentBuffer", function()
        if vim.bo.buftype == "terminal" then
            vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
        else
            local bufnr = vim.api.nvim_get_current_buf()
            vim.cmd("GoToPrev")
            vim.cmd("confirm bd" .. bufnr)
        end
    end, {})

    -- create command for comment divider snippets
    -- TODO: maybe split to another lua file like utils or something like that
    cmd("InsertCommentDivider", function()
        local mapped = {
            ["n"] = function()
                local line = vim.api.nvim_get_current_line()
                local empty = true and line == nil or line == "" or false

                -- format new line
                if empty == true then
                    -- get current cursor position
                    table.unpack = table.unpack or unpack
                    local _, _, _, _, cursor_position = table.unpack(vim.fn.getcurpos())
                    cursor_position = cursor_position - 1

                    -- quantity of ASCII characters for comment divider
                    local size = 94

                    if cursor_position > 0 then
                        size = size - cursor_position
                        line = string.rep(" ", cursor_position)
                            -- TODO: replace '/*' with info from vim.bo.comments
                            .. "/* "
                            .. string.rep("-", size)
                            .. " */"
                    else
                        line = "/* " .. string.rep("*", size) .. " */"
                    end
                else
                    -- trim all the whitespaces
                    line = line:gsub("^%s*(.-)%s*$", "%1")

                    -- length of current buffer line
                    local line_length = line:len()

                    -- calculate how many characters are needed for minimum seperator
                    -- /* - text - */
                    local delimiter_length = (92 - line_length) / 2

                    -- create left separator
                    local left = string.rep("-", delimiter_length)

                    -- if final string won't fill entire line (100 columns)
                    -- fix it by adding another delimiter to right side
                    if 96 > (line_length + 2 * delimiter_length) then
                        delimiter_length = delimiter_length + 1
                    end

                    -- create right separator
                    local right = string.rep("-", delimiter_length)

                    line = "/* " .. left .. " " .. line .. " " .. right .. " */"
                end

                vim.api.nvim_set_current_line(line)
            end,

            ["v"] = function()
                -- TODO: implement...
                -- local vstart = vim.fn.getpos("'<")
                -- local vend = vim.fn.getpos("'>")
                --
                -- local line_start = vstart[2]
                -- local line_end = vend[2]
                --
                -- -- or use api.nvim_buf_get_lines
                -- local lines = vim.fn.getline(line_start, line_end)
            end,
        }

        local mode = vim.fn.mode()

        if mapped[mode] then
            mapped[mode]()
        end
    end, {})
end

-- get a list of filtered buffers
M.bufilter = function()
    local bufs = vim.t.bufs or nil

    if not bufs then
        return {}
    end

    for i = #bufs, 1, -1 do
        if not vim.api.nvim_buf_is_valid(bufs[i]) and vim.bo[bufs[i]].buflisted then
            table.remove(bufs, i)
        end
    end

    return bufs
end

-- get a list of listed buffers =P
M.get_listed_buffers = function()
    local buffers = {}
    local len = 0
    for buffer = 1, vim.fn.bufnr("$") do
        if vim.fn.buflisted(buffer) == 1 then
            len = len + 1
            buffers[len] = buffer
        end
    end

    return buffers
end

-- check if must open nvdash
M.show_dashboard = function()
    local found_non_empty_buffer = false
    local buffers = M.get_listed_buffers()
    local count = 0

    for _, bufnr in ipairs(buffers) do
        count = count + 1
        if not found_non_empty_buffer then
            local name = vim.api.nvim_buf_get_name(bufnr)
            local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

            if name ~= "" and ft ~= "nvdash" then
                found_non_empty_buffer = true
            end
        end
    end

    if not found_non_empty_buffer then
        if count > 1 then
            require("neo-tree").close_all()
        end
        vim.cmd("Nvdash")
    end
end

return M
