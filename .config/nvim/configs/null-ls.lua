local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {

  b.formatting.deno_fmt,
  b.formatting.prettierd.with({ filetypes = { "html", "markdown", "css" } }),

  -- Lua
  b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),
  b.formatting.stylua,
  b.formatting.stylua.with({
    extra_args = { "--column-width", "80", "--indent-type", "Spaces" },
  }),

  -- Cpp
  b.formatting.clang_format,
  b.formatting.clang_format.with({
    extra_args = {
      "-style",
      "{BasedOnStyle: Google, Standard: c++17, ColumnLimit: 100}",
    },
  }),

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

  -- CMake
  b.formatting.cmake_format,

  -- snippets support
  b.completion.luasnip,
}

null_ls.setup({
  debug = true,
  sources = sources,

  -- on init
  on_init = function(new_client, _)
    new_client.offset_encoding = "utf-32"
  end,
})
