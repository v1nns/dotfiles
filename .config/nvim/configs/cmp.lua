local next = function(fallback)
  local cmp = require("cmp")
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local previous = function(fallback)
  local cmp = require("cmp")
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

local options = {
  mapping = {
    ["<Tab>"] = function(fallback)
      return next(fallback)
    end,

    ["<S-Tab>"] = function(fallback)
      return previous(fallback)
    end,

    ["<C-j>"] = function(fallback)
      return next(fallback)
    end,

    ["<C-k>"] = function(fallback)
      return previous(fallback)
    end,

    ["<CR>"] = function(fallback)
      return fallback()
    end,

    ["<C-Enter>"] = function(fallback)
      local cmp = require("cmp")
      if cmp.visible() then
        return cmp.confirm()
      else
        return fallback()
      end
    end,
  },
  completion = {
    completeopt = "menu,menuone,noselect",
  },
  enabled = function()
    -- disable completion in any telescope window
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if string.find(ft, "Telescope") then
      return false
    end

    -- disable completion in nvchad renamer
    local name = vim.api.nvim_buf_get_name(bufnr)
    if (name == nil or name == "") and (ft == nil or name == "") then
      return false
    end

    local context = require("cmp.config.context")

    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      -- disable completion in comments
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
  window = {
    completion = require("cmp").config.window.bordered(),
    documentation = require("cmp").config.window.bordered(),
  },
}

return options
