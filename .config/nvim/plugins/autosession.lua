local present, autosession = pcall(require, "auto-session")

if not present then
    return
end

-- set info to be saved with the underlying :mksession
vim.o.sessionoptions =
    "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

local options = {
    auto_session_suppress_dirs = { vim.env.HOME, "/tmp/" },
    auto_restore_enabled = true,
}

autosession.setup(options)
