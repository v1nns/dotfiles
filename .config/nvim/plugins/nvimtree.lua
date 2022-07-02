local M = {
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
        highlight_git = true,
        icons = {
            show = {
                git = true,
            },
        },
    },
}

return M
