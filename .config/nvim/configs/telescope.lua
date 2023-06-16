local options = {
    defaults = {
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        file_ignore_patterns = {
            ".cache",
            ".git",
            "node_modules",
            "build",
        },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = true,
        borderchars = {
            "─",
            "│",
            "─",
            "│",
            "╭",
            "╮",
            "╯",
            "╰",
        },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
            n = {
                ["q"] = require("telescope.actions").close,

                ["<C-k>"] = function(prompt_bufnr)
                    -- select previous entry
                    require("telescope.actions").move_selection_previous(prompt_bufnr)
                end,

                ["<C-j>"] = function(prompt_bufnr)
                    -- select next entry
                    require("telescope.actions").move_selection_next(prompt_bufnr)
                end,

                ["<C-BS>"] = { "<c-s-w>", type = "command" },
            },
            i = {
                ["<C-k>"] = function(prompt_bufnr)
                    -- select previous entry
                    require("telescope.actions").move_selection_previous(prompt_bufnr)
                end,

                ["<C-j>"] = function(prompt_bufnr)
                    -- select next entry
                    require("telescope.actions").move_selection_next(prompt_bufnr)
                end,

                ["<C-BS>"] = { "<c-s-w>", type = "command" },
            },
        },
    },
    -- builtins
    pickers = {
        find_files = {
            -- find_command = { "rg", "--files", "--sort", "path", "-F" },
            find_command = {
                "fd",
                "--type",
                "file",
                "--hidden",
                "--strip-cwd-prefix",
            },
            hidden = true,
            mappings = {
                i = {
                    ["<CR>"] = function(prompt_bufnr)
                        local actions = require("telescope.actions")
                        local entry = require("telescope.actions.state").get_selected_entry()

                        -- Use default action if entry does not contain a path
                        if not entry.path then
                            actions.select_default(prompt_bufnr)
                            return
                        end

                        -- Otherwise, close telescope and use nvim-window-picker to choose
                        -- which window to open new file buffer
                        actions.close(prompt_bufnr)

                        require("custom.configs.windowpicker").pick_window()
                        vim.cmd("edit " .. vim.fn.fnameescape(entry.path))
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
                    ["<CR>"] = require("telescope.actions").select_default + require(
                        "telescope.actions"
                    ).center,
                },
            },
        },
        lsp_document_symbols = {
            symbol_width = 80,
            mappings = {
                i = {
                    ["<CR>"] = require("telescope.actions").select_default + require(
                        "telescope.actions"
                    ).center,
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
