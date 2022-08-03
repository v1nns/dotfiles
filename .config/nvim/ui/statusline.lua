local sep_style = vim.g.statusline_sep_style
local separators = (type(sep_style) == "table" and sep_style)
    or require("nvchad_ui.icons").statusline_separators[sep_style]
local sep_l = separators["left"]
local sep_r = separators["right"]

return {
    fileInfo = function()
        local fn = vim.fn
        local icon = "  "
        local filename = (fn.expand("%") == "" and "Empty ") or fn.expand("%:t")

        if filename ~= "Empty " then
            local devicons_present, devicons = pcall(
                require,
                "nvim-web-devicons"
            )

            if devicons_present then
                local ft_icon = devicons.get_icon(filename)
                icon = (ft_icon ~= nil and " " .. ft_icon) or ""
            end

            filename = " " .. filename .. " "
        end

        -- Hide nvim-tree
        if string.find(filename, "NvimTree") then
            return ""
        else
            return "%#St_file_info#"
                .. icon
                .. filename
                .. "%#St_file_sep#"
                .. sep_r
        end
    end,
    cursor_position = function()
        local fn = vim.fn
        local api = vim.api
        local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

        local current_line = fn.line(".")
        local total_line = fn.line("$")
        local percent = math.modf((current_line / total_line) * 100)
        local text_line = string.format("%2d", percent) .. "%%"

        text_line = (current_line == 1 and "Top") or text_line
        text_line = (current_line == total_line and "Bot") or text_line

        local current_column = api.nvim_win_get_cursor(0)[2]
        local text_column = string.format("%3d", current_column)

        return left_sep
            .. "%#St_pos_text#"
            .. " "
            .. text_column
            .. " "
            .. text_line
            .. " "
    end,
}
