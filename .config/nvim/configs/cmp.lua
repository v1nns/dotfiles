local options = {
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
  },
}

return options
