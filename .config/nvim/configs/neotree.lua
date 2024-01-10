local options = {
    close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false, -- used when sorting files and directories in the tree
    sort_function = nil, -- use a custom function for sorting files and directories in the tree
    -- sort_function = function (a,b)
    --       if a.type == b.type then
    --           return a.path > b.path
    --       else
    --           return a.type > b.type
    --       end
    --   end , -- this sorts files and directories descendantly
    default_component_configs = {
        container = {
            enable_character_fade = true,
        },
        indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon",
        },
        modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
        },
        git_status = {
            symbols = {
                -- Change type
                added = "",
                modified = "",
                deleted = "✖",
                renamed = "",
                -- Status type
                untracked = "",
                ignored = "",
                unstaged = "",
                staged = "",
                conflict = "",
            },
        },
    },
    window = {
        position = "left",
        width = 40,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["o"] = { "toggle_node" },
            ["<space>"] = {
                "toggle_node",
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["<2-LeftMouse>"] = "open",
            ["<CR>"] = function(state)
                local node = state.tree:get_node()

                if node.type ~= "file" then
                    return
                end

                -- Use default action if node does not contain a path
                if not node.path then
                    require("neo-tree.sources.filesystem.commands").open(node)
                    return
                end

                require("custom.configs.windowpicker").pick_window()
                vim.cmd("edit " .. vim.fn.fnameescape(node.path))
            end,
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            ["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            -- ["E"] = "expand_all_nodes",
            ["a"] = {
                "add",
                -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                config = {
                    show_path = "absolute", -- "none", "relative", "absolute"
                },
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
        },
    },
    nesting_rules = {},
    filesystem = {
        components = {
            name = function(config, node, state)
                -- first call the default name component
                local cc = require("neo-tree.sources.common.components")
                local result = cc.name(config, node, state)

                local utils = require("neo-tree.utils")

                -- customize directory name to show only its name without absolute path
                if node:get_depth() == 1 then
                    local _, dir = utils.split_path(state.path)
                    result.text = "[" .. dir .. "]"
                end
                return result
            end,
        },
        bind_to_cwd = true, -- true creates a 2-way binding between vim's cwd and neo-tree's root
        filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
                "node_modules",
            },
            hide_by_pattern = { -- uses glob style patterns
                --"*.meta",
                --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
                -- ".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                --".DS_Store",
                --"thumbs.db"
                ".git",
            },
        },
        follow_current_file = { enabled = true }, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
        -- in whatever position is specified in window.position
        -- "open_current",  -- netrw disabled, opening a directory opens within the
        -- window like netrw would, regardless of window.position
        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
            mappings = {
                -- ["<bs>"] = "navigate_up",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["D"] = "fuzzy_finder_directory",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["E"] = function(state, toggle_directory)
                    local fs = require("neo-tree.sources.filesystem")
                    local renderer = require("neo-tree.ui.renderer")
                    local utils = require("neo-tree.utils")

                    if toggle_directory == nil then
                        toggle_directory = function(_state, node)
                            fs.toggle_directory(_state, node, nil, true, true)
                        end
                    end

                    local expand_node
                    expand_node = function(node)
                        -- custom code (based on expand_all_nodes command)
                        if node:get_depth() > 1 then
                            local _, folder = utils.split_path(node.path)
                            local output = vim.fn.systemlist({
                                "git",
                                "check-ignore",
                                folder,
                            })

                            if output[1] ~= nil then
                                -- at this point, it means that this folder is part of
                                -- .gitignore file and should not be expanded
                                return
                            end
                        end
                        -- end custom code

                        local id = node:get_id()
                        if node.type == "directory" and not node:is_expanded() then
                            toggle_directory(state, node)
                            node = state.tree:get_node(id)
                        end
                        local children = state.tree:get_nodes(id)
                        if children then
                            for _, child in ipairs(children) do
                                if child.type == "directory" then
                                    expand_node(child)
                                end
                            end
                        end
                    end

                    for _, node in ipairs(state.tree:get_nodes()) do
                        expand_node(node)
                    end
                    renderer.redraw(state)
                end,
            },
            fuzzy_finder_mappings = {
                ["<down>"] = "move_cursor_down",
                ["<C-j>"] = "move_cursor_down",
                ["<up>"] = "move_cursor_up",
                ["<C-k>"] = "move_cursor_up",
            },
        },
    },
    buffers = {
        components = {
            name = function(config, node, state)
                -- first call the default name component
                local cc = require("neo-tree.sources.buffers.components")
                local result = cc.name(config, node, state)

                -- customize title
                if node:get_depth() == 1 then
                    result.text = "[OPEN BUFFERS]"
                end
                return result
            end,
        },
        follow_current_file = { enabled = true }, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = {
            mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                -- ["."] = "set_root",
            },
        },
    },
    git_status = {
        components = {
            name = function(config, node, state)
                -- first call the default name component
                local cc = require("neo-tree.sources.git_status.components")
                local result = cc.name(config, node, state)

                -- customize title
                if node.type == "directory" then
                    if node:get_depth() == 1 then
                        if node:has_children() then
                            result.text = "[GIT STATUS]"
                        else
                            result.text = "[GIT STATUS] (working tree clean)"
                        end
                    end
                end
                return result
            end,
        },
        window = {
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                -- TODO: map <CR> to execute :Gitsign diffthis
            },
        },
    },
    source_selector = {
        winbar = false, -- toggle to show selector on winbar
        statusline = false, -- toggle to show selector on statusline
    },
}

return options
