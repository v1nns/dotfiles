local M = {}

M.setup = function()
    local options = { performance_mode = true }
    require("neoscroll").setup(options)

    local t = {}

    -- Syntax: t[keys] = {function, {function arguments}}
    -- Use the "sine" easing function
    t["<C-u>"] = {
        "scroll",
        { "-vim.wo.scroll", "true", "100", [['sine']] },
    }
    t["<C-d>"] = {
        "scroll",
        { "vim.wo.scroll", "true", "100", [['sine']] },
    }

    require("neoscroll.config").set_mappings(t)
end

return M
