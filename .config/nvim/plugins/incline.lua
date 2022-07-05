local present, incline = pcall(require, "incline")

if not present then
    return
end

local a = vim.api
local render = function(props)
    local bufname = a.nvim_buf_get_name(props.buf)
    local res = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t")
        or "[No Name]"
    if a.nvim_buf_get_option(props.buf, "modified") then
        res = res .. " [+]"
    end
    return { res, guibg = "#7575F0", guifg = "#E3F2FD", ctermbg = "LightBlue" }
end

local options = {
    debounce_threshold = {
        falling = 50,
        rising = 10,
    },
    hide = {
        cursorline = false,
        focused_win = false,
        only_win = true,
    },
    highlight = {
        groups = {
            InclineNormal = {
                default = true,
                group = "NormalFloat",
            },
            InclineNormalNC = {
                default = true,
                group = "NormalFloat",
            },
        },
    },
    ignore = {
        buftypes = "special",
        filetypes = {},
        floating_wins = true,
        unlisted_buffers = true,
        wintypes = "special",
    },
    render = render,
    window = {
        margin = {
            horizontal = 0,
            vertical = { top = 0, bottom = 0 },
        },
        options = {
            signcolumn = "no",
            wrap = false,
        },
        padding = 1,
        padding_char = " ",
        placement = {
            horizontal = "left",
            vertical = "top",
        },
        width = "fit",
        winhighlight = {
            active = {
                EndOfBuffer = "None",
                Normal = "InclineNormal",
                Search = "None",
            },
            inactive = {
                EndOfBuffer = "None",
                Normal = "InclineNormalNC",
                Search = "None",
            },
        },
        zindex = 50,
    },
}

incline.setup(options)
