local options = {
  view = {
    hide_root_folder = false,
  },
  git = {
    enable = true,
  },
  actions = {
    change_dir = {
      restrict_above_cwd = true,
    },
  },
  renderer = {
    symlink_destination = false,
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  filters = { custom = { "^.git$" } },
}

return options
