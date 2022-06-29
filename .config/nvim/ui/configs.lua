-- overriding ui configs!

local M = {}

-- remove button from bufferline
M.tabufline = {
    buttons = function()
        local CloseAllBufsBtn = "%@TbCloseAllBufs@%#TbLineCloseAllBufsBtn#" .. "  " .. "%X"
        return CloseAllBufsBtn
    end
}

return M