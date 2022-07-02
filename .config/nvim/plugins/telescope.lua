local M = function()
    return {
        defaults = {
            mappings = {
                i = {
                    -- remap to change cwd and close window
                    -- ["<C-Enter>"] = function(prompt_bufnr)
                    --     local buf_name = vim.api.nvim_buf_get_name(0)
                    --     if buf_name ~= "" and vim.bo.modified then
                    --       print "save the file bruh"
                    --     else
                    --     require("telescope").extensions.file_browser.actions.change_cwd(prompt_bufnr)
                    --     require("telescope.actions").close(prompt_bufnr)
                    --     vim.cmd(":NvimTreeClose")
                    --     vim.cmd("bufdo bd")
                    --     vim.cmd(":NvimTreeOpen")
                    --     end
                    -- end,

                    -- disable default change_cwd
                    ["<C-o>"] = false,
                    ["<C-t>"] = false,
                    ["<C-u>"] = false,
                    -- ["<C-x>"] = function(prompt_bufnr)
                    --   -- your custom function
                    -- end
                },
                n = {
                    ["q"] = require("telescope.actions").close,
                },
            },
        },
        pickers = {
            find_files = {
                -- find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "-H", "-E", ".git", "-E", "node_modules" }
                -- file_ignore_patterns = { ".git", "node_modules" },
            },
            live_grep = {
                grep_open_files = false,
                additional_args = function()
                    return { "--hidden" }
                end,
            },
        },
        extensions_list = { "themes", "terms", "opener" },
    }
end

return M
