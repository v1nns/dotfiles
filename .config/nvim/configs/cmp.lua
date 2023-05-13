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
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "neorg" },
  },
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
      local cmp = require("cmp")
      if cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
    end,
  },
  completion = {
    completeopt = "menuone,noselect",
  },
  enabled = function()
    -- disable completion in telescope window
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')

    if string.find(ft, "Telescope") then return false end

    -- disable completion in comments
    local context = require "cmp.config.context"

    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
}

return options
