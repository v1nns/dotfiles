local options = {
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    cmdline = {
        format = {
            cmdline = {
                pattern = "^:",
                icon = "",
                lang = "vim",
                opts = { border = { text = { top = " Command " } } },
            },
            substitute = {
                pattern = "^:%%?s/",
                icon = "󰛔",
                ft = "regex",
                opts = { border = { text = { top = " Replace (old/new/) " } } },
            },
            tabrename = {
                pattern = "^:TabRename ",
                icon = "",
                ft = "regex",
                opts = { border = { text = { top = " Rename tab " } } },
            },
            filetype = {
                pattern = "^:setf ",
                icon = "󰏫",
                ft = "regex",
                opts = { border = { text = { top = " Set filetype " } } },
            },
        },
    },
    messages = {
        view_search = false,
    },
    routes = {
        {
            filter = {
                event = "msg_show",
                any = {
                    { find = "%d+L, %d+B" },
                    { find = "; after #%d+" },
                    { find = "; before #%d+" },
                    { find = "%d fewer lines" },
                    { find = "%d more lines" },
                },
            },
            opts = { skip = true },
        },
    },
}

return options
