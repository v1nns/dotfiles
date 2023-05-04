local config = require("core.utils").load_config().ui.statusline
local sep_style = config.separator_style

local default_sep_icons = {
  default = {
    left = "",
    right = " "
  },
  round = {
    left = "",
    right = ""
  },
  block = {
    left = "█",
    right = "█"
  },
  arrow = {
    left = "",
    right = ""
  }
}

local separators = (type(sep_style) == "table" and sep_style) or default_sep_icons[sep_style]

local sep_l = separators["left"]

return {
  fileInfo = function()
    return "%#StText# "
  end,

  git = function()
    if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
      return ""
    end

    return "%#GitBranch#  " .. vim.b.gitsigns_status_dict.head .. "  %*"
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

    return left_sep .. "%#St_pos_text#" .. " " .. text_column .. " " .. text_line .. " "
  end
}
