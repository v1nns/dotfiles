local options = {
    defaults = {
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,
            },
        },
    },
    -- builtins
    pickers = {
        find_files = {
            find_command = function()
                return {
                    "fd",
                    "--type",
                    "f",
                    "--strip-cwd-prefix",
                    "-H",
                    "-E",
                    ".cache",
                    "-E",
                    ".git",
                    "-E",
                    "node_modules",
                    "-E",
                    "build",
                }
            end,
            no_ignore = true,
            no_ignore_parent = true,
            mappings = {
                i = {
                    ["<CR>"] = function(prompt_bufnr)
                        local success, wp = pcall(require, "window-picker")
                        local actions = require("telescope.actions")
                        local entry =
                            require("telescope.actions.state").get_selected_entry()

                        -- In case, that nvim-window-picker is not installed, use default action
                        if not success or not entry.path then
                            actions.select_default(prompt_bufnr)
                            return
                        end

                        -- otherwise, close telescope and use nvim-window-picker to choose
                        -- which window to open new file buffer
                        actions.close(prompt_bufnr)

                        local picked_window_id = wp.pick_window()
                        if picked_window_id then
                            vim.api.nvim_set_current_win(picked_window_id)
                            vim.cmd(
                                "edit " .. vim.fn.fnameescape(entry.path)
                            )
                        end
                    end,
                },
            },
        },
        live_grep = {
            grep_open_files = false,
            additional_args = function()
                return {
                    "--hidden",
                    "-g",
                    "!.cache/*",
                    "-g",
                    "!.git/*",
                    "-g",
                    "!node_modules/*",
                    "-g",
                    "!build/*",
                }
            end,
            mappings = {
                i = {
                    ["<CR>"] = require("telescope.actions").select_default
                        + require("telescope.actions").center,
                },
            },
        },
        lsp_document_symbols = {
            mappings = {
                i = {
                    ["<CR>"] = require("telescope.actions").select_default
                        + require("telescope.actions").center,
                },
            },
        },
    },
    extensions = {
        file_browser = require("custom.configs.filebrowser"),
    },
    extensions_list = {
        "themes",
        "terms",
        "file_browser",
    },
}

return options
