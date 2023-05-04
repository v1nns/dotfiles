local M = {}

M.add = {
    -- quickscope highlight colors
    QuickScopePrimary = {
        fg = "#afff5f",
    },
    QuickScopeSecondary = {
        fg = "#5fffff",
    },

    -- virt-column color
    VirtColumn = {
        fg = "#992975",
    },

   -- statusline git-branch color
    GitBranch = {
        fg = "#bb9af7",
        bg = "#1f202b",
    },

    -- neo-tree
    NeoTreeNormal = { bg = "#16161e" },
    NeoTreeNormalNC = { bg = "#16161e" },
    NeoTreeTitle = { fg = "#16161e" },
    NeoTreeRootName = { underline = false, bold = true },

    NeoTreeCursorLine = { bg = "#292e42" },
    -- NeoTreeDirectoryName = { fg = "#c0caf5" },

    NeoTreeGitStaged = { fg = "#7ece6a" },
    NeoTreeGitUnstaged = { fg = "#e0af68" },

    NeoTreeGitAdded = { fg = "#7ece6a" },
    NeoTreeGitDeleted = { fg = "#f7768e" },

    NeoTreeGitModified = { fg = "#e0af68" },
    NeoTreeGitUntracked = { fg = "#b4f9f8" },

    --- Types
    ["@type.definition"] = { fg = "#bb9af7" },
    ["@type.qualifier"] = { fg = "#bb9af7" },
    ["@attribute"] = {fg="#b4f9f8"},
    ["@boolean"]= { fg = "#ff9e64" },
    ["@number"]= { fg = "#ff9e64" },
    ["@class.name"] = { fg = "#c0caf5"},
    ["@function.type"] = { fg = "#9abdf5"},
    ["@text.todo"] = { bg =  "#e0af68", fg = "#2f3549", bold=true },
    ["@text.danger"] = { bg =  "#f7778e", fg = "#2f3549", bold=true },
    ["@text.warning"] = { bg =  "#ff9364", fg = "#2f3549", bold=true },
    ["@text.note"] = { bg =  "#73daca", fg = "#2f3549", bold=true },
}

M.override = {
    NvDashAscii = {
        bg = "none",
        fg = "white",
    },
    Comment = {
        fg = "#4caf50",
        italic = false,
    },
    NonText = {
        fg = "#ff2233",
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

    ["@namespace"] = { fg = "#c0caf5" },
    ["@type"] = { fg = "#bb9af7" },
    ["@type.builtin"] = { fg = "#bb9af7"},
    ["@field"] = { fg =  "#9abdf5"}, -- For fields.
    ["@property"] = { fg = "#9abdf5" },

    -- change indent-blankline color
    -- IndentBlanklineChar = { fg= "#444b6a" },
    IndentBlanklineContextChar = { fg = "#787c99" },
}

M.changed_themes = {
    tokyonight = {
        base_16 = {
            base00 = "#1a1b26",
            base01 = "#16161e",
            base02 = "#2f3549",
            base03 = "#444b6a",
            base04 = "#787c99",
            base05 = "#a9b1d6",
            base06 = "#cbccd1",
            base07 = "#d5d6db",
            base08 = "#c0caf5",
            base09 = "#a9b1d6",
            base0A = "#0db9d7",
            base0B = "#9ece6a",
            base0C = "#b4f9f8",
            base0D = "#2ac3de",
            base0E = "#bb9af7",
            base0F = "#f7768e",
        },

        polish_hl = {
            ["@method"] = {fg = "#7aa2f7"},
            ["@method.call"] = {fg = "#7aa2f7"},
            ["@function"] = { fg = "#7aa2f7"},
            ["@function.call"] = { fg = "#7aa2f7"},
            ["@constant"] = { fg = "#ff9e64" },

            ["@operator"] = { fg = "#89ddff" }, -- For any operator: `+`, but also `->` and `*` in C.

            --- Punctuation
            ["@punctuation.delimiter"] = { fg = "#89ddff" }, -- For delimiters ie: `.`
            ["@punctuation.bracket"] = { fg = "#a9b1d6" }, -- For brackets and parens.
            ["@punctuation.special"] = { fg = "#89ddff" }, -- For special punctutation that does not fall in the catagories before.
            ["@punctuation.special.markdown"] = { fg = "#ff9e64", bold = true },

            --- Literals
            ["@string.documentation"] = { fg =  "#e0af68" },
            ["@string.regex"] = { fg = "#b4f9f8" }, -- For regexes.
            ["@string.escape"] = { fg = "#bb9af7" }, -- For escape characters within a string.

            --- Functions
            ["@constructor"] = { fg = "#7aa2f7" }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
            ["@parameter"] = { fg = "#e0af68" }, -- For parameters of a function.
            -- TODO:
            -- ["@parameter.builtin"] = {}, -- For builtin parameters of a function, e.g. "..." or Smali's p[1-99]

            --- Keywords
            ["@keyword"] = { fg = "#9d7cd8", bold = true }, -- For keywords that don't fall in previous categories.
            -- TODO:
            -- ["@keyword.coroutine"] = { }, -- For keywords related to coroutines.
            ["@keyword.function"] = { fg = "#bb9af7" }, -- For keywords used to define a fuction.

            ["@label"] = { fg = "#7aa2f7" }, -- For labels: `label:` in C and `:label:` in Lua.

            --- Identifiers
            ["@variable"] = { fg = "#9abdf5" }, -- Any variable name that does not have another highlight.
            ["@variable.builtin"] = { fg = "#f7768e" }, -- Variable names that are defined by the languages, like `this` or `self`.

            --- Text
            -- ["@text.literal.markdown"] = { fg = c.blue },
            ["@text.literal.markdown_inline"] = { bg = "#414868", fg =  "#7aa2f7"},
            ["@text.reference"] = { fg =  "#1abc9c"},

            ["@text.todo.unchecked"] = { fg =  "#7aa2f7"}, -- For brackets and parens.
            ["@text.todo.checked"] = { fg =  "#73daca" }, -- For brackets and parens.
            -- ["@text.warning"] = { fg = "#24283b", bg = c.warning },
            -- ["@text.danger"] = { fg = "#24283b", bg = c.error },

            ["@text.diff.add"] = { link = "DiffAdd" },
            ["@text.diff.delete"] = { link = "DiffDelete" },
        },
    },
}

return M
