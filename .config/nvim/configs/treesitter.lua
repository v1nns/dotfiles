local options = {
  ensure_installed = {
    "vim",
    "vimdoc",
    "html",
    "css",
    "javascript",
    "json",
    "toml",
    "markdown",
    "c",
    "cpp",
    "bash",
    "lua",
    "python",
    "cmake",
    "make",
    -- "comment",
    "yaml",
    "yang",
  },

  highlight = {
    enable = true,

    -- Use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(_, buf)
      local max_filesize = 200 * 1024       -- 200 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

return options
