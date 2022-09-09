local M = {}

M.add = function()
    return {
        -- quickscope highlight colors
        QuickScopePrimary = {
            fg = "#AFFF5F",
        },
        QuickScopeSecondary = {
            fg = "#5FFFFF",
        },

        -- virt-column color
        VirtColumn = {
            fg = "#592929",
        },

        -- neovim tree-sitter
        TSBoolean = { fg = "#7dcfff" },
        TSConstant = { fg = "#e0af68" },
        TSConstBuiltin = { fg = "#e0af68" },
        TSConstMacro = { fg = "#e0af68" },
        TSDanger = { fg = "#1a1b26", bg = "#db4b4b" },
        TSLabel = { fg = "#7aa2f7" },
        TSNumber = { fg = "#ff9e64" },
        TSNote = { fg = "#1a1b26", bg = "#0db9d7" },
        TSOperator = { fg = "#89ddff" },
        TSTextReference = { fg = "#1abc9c" },
        TSType = { fg = "#bb9af7" },
        TSTypeDefinition = { fg = "#7dcfff" },
        TSTypeQualifier = { fg = "#7dcfff" },
        TSWarning = { fg = "#1a1b26", bg = "#e0af68" },

        -- neo-tree
        NeoTreeNormal = { bg = "#16161e" },
        NeoTreeNormalNC = { bg = "#16161e" },
        NeoTreeTitle = { fg = "#16161e" },
        NeoTreeRootName = { underline = false, bold = true },

        NeoTreeCursorLine = { bg = "#292e42" },
        -- NeoTreeDirectoryName = { fg = "#c0caf5" },

        NeoTreeGitModified = { fg = "#e0af68" },
        NeoTreeGitUntracked = { fg = "#b4f9f8" },
    }
end

M.override = function()
    return {
        AlphaHeader = {
            fg = "#B388FF",
        },
        Comment = {
            fg = "#4CAF50",
        },
        NonText = {
            fg = "#FF2233",
        },
        -- WinSeparator = {
        --     fg = "#484852",
        -- },

        -- nvimtree
        NvimTreeRootFolder = {
            fg = "#0db9d7",
        },
        NvimTreeSpecialFile = {
            fg = "#bb9af7",
        },
        NvimTreeFolderName = {
            fg = "#c0caf5",
        },
        NvimTreeGitNew = {
            fg = "#b4f9f8",
        },
        NvimTreeGitDirty = {
            fg = "#e0af68",
        },

        -- diffview
        DiffAdd = {
            fg = "#7ece6a",
        },
        DiffDelete = {
            fg = "#f7768e",
        },

        -- These groups are for the neovim tree-sitter highlights.
        TSFuncBuiltin = { fg = "#7aa2f7" }, -- For builtin functions: `table.insert` in Lua.
        TSFunction = { fg = "#7aa2f7" }, -- For function (calls and definitions).
        TSInclude = { fg = "#7dcfff" }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
        TSKeyword = { fg = "#9d7cd8" }, -- For keywords that don't fall in previous categories.
        TSKeywordFunction = { fg = "#bb9af7" }, -- For keywords used to define a fuction.
        TSKeywordOperator = { fg = "#9d7cd8" },
        TSMethod = { fg = "#7aa2f7" }, -- For builtin functions: `table.insert` in Lua.
        TSNamespace = { fg = "#f7768e" }, -- For identifiers referring to modules and namespaces.
        TSParameter = { fg = "#e0af68" }, -- For parameters of a function.
        TSProperty = { fg = "#73daca" }, -- Same as `TSField`.
        TSPunctBracket = { fg = "#a9b1d6" }, -- For brackets and parens.
        TSPunctDelimiter = { fg = "#89ddff" }, -- For delimiters ie: `.`
        TSPunctSpecial = { fg = "#89ddff" }, -- For special punctutation that does not fall in the catagories before.
        TSStringRegex = { fg = "#b4f9f8" }, -- For regexes.
        TSTypeBuiltin = { fg = "#bb9af7" }, -- For builtin types.
        TSVariable = { fg = "#c0caf5" }, -- Any variable name that does not have another highlight.
        TSVariableBuiltin = { fg = "#c0caf5" }, -- Variable names that are defined by the languages, like `this` or `self`.
    }
end

return M
