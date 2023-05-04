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
      local cmp = require("cmp")
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,

    ["<S-Tab>"] = function(fallback)
      local cmp = require("cmp")
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
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
}

return options
