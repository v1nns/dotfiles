local options = {
  current_line_blame_opts = {
    delay = 300,
  },
  current_line_blame_formatter = "<abbrev_sha> (<author>, <author_time:%Y-%m-%d>) <summary>",
  signs = {
    add = { hl = "GitSignDiffAdd", text = "│", numhl = "GitSignsAddNr" },
    change = {
      hl = "GitSignDiffChange",
      text = "│",
      numhl = "GitSignsChangeNr",
    },
    delete = {
      hl = "GitSignDiffDelete",
      text = "󰍵",
      numhl = "GitSignsDeleteNr",
    },
    topdelete = {
      hl = "GitSignDiffDelete",
      text = "‾",
      numhl = "GitSignsDeleteNr",
    },
    changedelete = {
      hl = "DiffChangeDelete",
      text = "~",
      numhl = "GitSignsChangeNr",
    },
    untracked = {
      hl = "GitSignsAdd",
      text = "│",
      numhl = "GitSignsAddNr",
      linehl = "GitSignsAddLn",
    },
  },
  _git_version = "2.43.0",
}

return options
