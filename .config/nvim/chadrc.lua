local M = {}

local uiCfg = require("custom.ui.configs")

M.options = {
    -- load custom options here
    user = function()
        -- visual column (used with virt-column plugin)
        vim.opt.colorcolumn = "100"

        -- show trailing spaces and tabs
        vim.opt.list = true
        vim.opt.listchars = {
            trail = "~", --[[ tab = ">>" ]]
        }

        -- quickscope highlight colors
        vim.cmd(
            [[highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline]]
        )
        vim.cmd(
            [[highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline]]
        )

        -- highlight config files
        local autocmd = vim.api.nvim_create_autocmd
        autocmd(
            { "BufEnter", "BufRead" },
            { pattern = "*conf*", command = "setf dosini" }
        )

        -- set winbar with breadcrumbs and file path
        vim.o.winbar = " %{%v:lua.require'nvim-navic'.get_location()%}%=%m %f"

        -- to debug lspconfig, use this below and :LspLog
        -- vim.lsp.set_log_level("debug")
    end,
}

M.ui = {
    hl_override = {
        AlphaHeader = {
            fg = "#B388FF",
        },
        -- AlphaButtons = {
        --     fg = "#FF2233",
        -- },
        ColorColumn = {
            bg = "#C36854",
        },
        Comment = {
            fg = "#4CAF50",
        },
        NonText = {
            fg = "#FF2233",
        },
    },

    theme = "aquarium",

    statusline = {
        separator_style = "block",
        override = {
            fileInfo = uiCfg.statusline_fileinfo,
            cursor_position = uiCfg.statusline_cursorposition,
        },
    },

    tabufline = {
        override = uiCfg.tabufline,
    },
}

M.plugins = {
    options = {
        lspconfig = {
            setup_lspconf = "custom.plugins.lspconfig",
        },
    },

    -- Override default config of a plugin (merging)
    override = {
        ["goolord/alpha-nvim"] = require("custom.plugins.alpha"),
        ["nvim-treesitter/nvim-treesitter"] = require(
            "custom.plugins.treesitter"
        ),
        ["kyazdani42/nvim-tree.lua"] = require("custom.plugins.nvimtree"),
        ["hrsh7th/nvim-cmp"] = require("custom.plugins.cmp"),
        ["lukas-reineke/indent-blankline.nvim"] = require(
            "custom.plugins.blankline"
        ),
        ["nvim-telescope/telescope.nvim"] = require("custom.plugins.telescope"),
        ["lewis6991/gitsigns.nvim"] = require("custom.plugins.gitsigns"),
    },

    -- Replace default config of a plugin (or add a new plugin)
    user = {
        -- enable greeter screen
        ["goolord/alpha-nvim"] = {
            disable = false,
        },

        -- open directories and session management
        -- ["rmagatti/auto-session"] = {},
        ["nvim-telescope/telescope-file-browser.nvim"] = {},

        -- ["nvim-telescope/telescope-ui-select.nvim"] = {},
        -- ["nvim-telescope/telescope-project.nvim"] = {},
        -- ["shatur/neovim-session-manager"] = {},

        -- code navigation and highlight
        ["easymotion/vim-easymotion"] = {},
        ["unblevable/quick-scope"] = {},

        -- breadcrumbs
        ["SmiteshP/nvim-navic"] = {
            config = function()
                require("custom.plugins.navic")
            end,
        },

        -- format and lint
        ["jose-elias-alvarez/null-ls.nvim"] = {
            after = "nvim-lspconfig",
            config = function()
                require("custom.plugins.null-ls")
            end,
        },

        -- UI improvement
        ["luukvbaal/stabilize.nvim"] = {},
        ["lukas-reineke/virt-column.nvim"] = {
            config = function()
                require("custom.plugins.virt-column")
            end,
        },
    },
}

M.mappings = require("custom.mappings")

return M
