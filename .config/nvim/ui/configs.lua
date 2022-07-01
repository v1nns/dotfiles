-- overriding ui configs!

local M = {}

-- remove button from bufferline
M.tabufline = {
    buttons = function()
        local CloseAllBufsBtn = "%@TbCloseAllBufs@%#TbLineCloseAllBufsBtn#" .. "  " .. "%X"
        return CloseAllBufsBtn
    end
}

M.statusline_fileinfo = function()
   local fn = vim.fn
   local icon = "  "
   local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"

   local sep_style = require("ui.icons").statusline_separators
   local sep_r = sep_style["block"]["right"]

   if filename ~= "Empty " then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

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
    return "%#St_file_info#" .. icon .. filename .. "%#St_file_sep#" .. sep_r
   end
end

M.statusline_cursorposition = function()
   local fn = vim.fn
   local sep_style = require("ui.icons").statusline_separators
   local sep_l = sep_style["block"]["left"]

   local left_sep = "%#St_pos_sep#" .. sep_l .. "%#St_pos_icon#" .. " "

   local current_line = fn.line "."
   local total_line = fn.line "$"
   local percent = math.modf((current_line / total_line) * 100)
   local text = string.format("%2d", percent) .. "%%"

   text = (current_line == 1 and "Top") or text
   text = (current_line == total_line and "Bot") or text

   return left_sep .. "%#St_pos_text#" .. " " .. text .. " "
end

return M
