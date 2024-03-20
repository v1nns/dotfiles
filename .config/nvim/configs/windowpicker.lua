local M = {}

M.pick_window = function()
  -- Check if got enough windows to select, otherwise do not execute window-picker extension
  local all_windows = vim.api.nvim_tabpage_list_wins(0)
  local count = 0

  for _, v in pairs(all_windows) do
    local bufnr = vim.api.nvim_win_get_buf(v)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    -- must filter it manually, otherwise window-picker will recognize it unproperly
    if ft ~= "neo-tree" then
      count = count + 1
    end
  end

  if count <= 1 then
    return true
  end

  local options = {
    hint = "floating-big-letter",
    prompt_message = "",

    selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",

    filter_rules = {
      autoselect_one = true,
      include_current_win = true,

      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = {
          "neo-tree",
          "neo-tree-popup",
          "notify",
          "quickfix",
          "*Telescope*",
          -- "nvdash", -- we can't filter nvdash...
        },

        -- if the buffer type is one of following, the window will be ignored
        buftype = { "terminal", "nofile" },
      },
    },

    highlights = {
      statusline = {
        focused = {
          -- fg = "#ededed",
          fg = "#f9c495",
          bg = "#e35e4f",
          bold = true,
          -- underline = true,
        },
        unfocused = {
          fg = "#16161e",
          bg = "#e35e4f",
          bold = true,
        },
      },
    },
  }

  local window_id = require("window-picker").pick_window(options)

  if not window_id then
    return false
  end

  vim.api.nvim_set_current_win(window_id)
  return true
end

return M
