-- Custom browse_files for telescope-file-browser extension
-- Using it specifically to browse directories-only
-- P.S. depends on 'fd'
local browse_files = function(opts)
    local Path = require("plenary.path")
    local async_oneshot_finder = require(
        "telescope.finders.async_oneshot_finder"
    )

    opts = opts or {}

    -- returns copy with properly set cwd for entry maker
    local entry_maker = opts.entry_maker({ cwd = opts.path })
    local parent_path = Path:new(opts.path):parent():absolute()
    local args = { "-a", "--type", "d", "-d", "1", "--strip-cwd-prefix", "-I" }

    return async_oneshot_finder({
        fn_command = function()
            return { command = "fd", args = args }
        end,
        entry_maker = entry_maker,
        results = not opts.hide_parent_dir and { entry_maker(parent_path) }
            or {},
        cwd = opts.path,
    })
end

local M = {
    mappings = {
        i = {
            -- remap to change cwd and close window
            ["<C-Enter>"] = function(prompt_bufnr)
                local buf_name = vim.api.nvim_buf_get_name(0)
                if buf_name ~= "" and vim.bo.modified then
                    print("save the file bruh")
                else
                    require("telescope").extensions.file_browser.actions.change_cwd(
                        prompt_bufnr
                    )
                    require("telescope.actions").close(prompt_bufnr)
                    vim.cmd(":NvimTreeClose")
                    vim.cmd("bufdo bd")
                    vim.cmd(":NvimTreeOpen")
                end
            end,

            -- disable default change_cwd
            ["<C-o>"] = false,
            ["<C-t>"] = false,
            ["<C-u>"] = false,
            -- ["<C-x>"] = function(prompt_bufnr)
            --   -- your custom function
            -- end
        },
    },
    browse_files = browse_files,
}

return M
