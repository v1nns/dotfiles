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
        WinSeparator = {
            fg = "#484852",
        },

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
        TSBoolean = { fg = "#7dcfff" },
        TSConstMacro = { fg = "#9d7cd8" },
        TSDanger = { fg = "#1a1b26", bg = "#db4b4b" },
        TSFuncBuiltin = { fg = "#7aa2f7" }, -- For builtin functions: `table.insert` in Lua.
        TSFunction = { fg = "#7aa2f7" }, -- For function (calls and definitions).
        TSInclude = { fg = "#7dcfff" }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
        TSKeyword = { fg = "#9d7cd8" }, -- For keywords that don't fall in previous categories.
        TSKeywordFunction = { fg = "#bb9af7" }, -- For keywords used to define a fuction.
        TSKeywordOperator = { fg = "#9d7cd8" },
        TSLabel = { fg = "#7aa2f7" }, -- For labels: `label:` in C and `:label:` in Lua.
        TSMethod = { fg = "#7aa2f7" }, -- For builtin functions: `table.insert` in Lua.
        TSNamespace = { fg = "#f7768e" }, -- For identifiers referring to modules and namespaces.
        TSNote = { fg = "#1a1b26", bg = "#0db9d7" },
        TSOperator = { fg = "#89ddff" }, -- For any operator: `+`, but also `->` and `*` in C.
        TSParameter = { fg = "#e0af68" }, -- For parameters of a function.
        TSProperty = { fg = "#73daca" }, -- Same as `TSField`.
        TSPunctBracket = { fg = "#a9b1d6" }, -- For brackets and parens.
        TSPunctDelimiter = { fg = "#89ddff" }, -- For delimiters ie: `.`
        TSPunctSpecial = { fg = "#89ddff" }, -- For special punctutation that does not fall in the catagories before.
        TSStringRegex = { fg = "#b4f9f8" }, -- For regexes.
        TSTextReference = { fg = "#1abc9c" },
        TSType = { fg = "#bb9af7" }, -- For types.
        TSTypeBuiltin = { fg = "#bb9af7" }, -- For builtin types.
        TSTypeDefinition = { fg = "#7dcfff" },
        TSTypeQualifier = { fg = "#7dcfff" },
        TSVariable = { fg = "#c0caf5" }, -- Any variable name that does not have another highlight.
        TSVariableBuiltin = { fg = "#c0caf5" }, -- Variable names that are defined by the languages, like `this` or `self`.
        TSWarning = { fg = "#1a1b26", bg = "#e0af68" },
    }
end

return M
