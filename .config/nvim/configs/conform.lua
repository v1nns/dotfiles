local options = {
    -- Define all formatters
    formatters_by_ft = {
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        lua = { "stylua" },
        javascript = { { "prettierd", "prettier" } },
        python = { "autopep8" },
        shell = { "shfmt" },
    },
    -- Set up format-on-save
    format_on_save = nil,
    -- Customize formatters
    formatters = {
        autopep8 = {
            prepend_args = { "--max-line-length", "100" },
        },
        clang_format = {
            prepend_args = {
                "--style",
                "{BasedOnStyle: Google, Standard: c++17, ColumnLimit: 100}",
            },
        },
        stylua = {
            prepend_args = { "--column-width", "100", "--indent-type", "Spaces" },
        },
        shfmt = {
            prepend_args = { "-i", "4" },
        },
    },
}

return options
