local M = {}

-- Autocommands
M.setup_autocommands = function()
  local autocmd = vim.api.nvim_create_autocmd

  -- setup title string
  autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
      -- TODO: show empty when in HOME?
      local cwd = vim.fn.getcwd()
      vim.o.titlestring = vim.fn.fnamemodify(cwd, ":t") .. " - " .. cwd
    end,
  })

  -- force highlights reload
  autocmd({ "VimEnter", "DirChanged" }, {
    callback = function()
      require("base46").load_all_highlights()
    end,
  })

  -- highlight config files
  autocmd(
    { "BufEnter", "BufRead" },
    { pattern = "*.*conf*", command = "setf dosini" }
  )

  -- auto-wrap comments, don't auto insert comment on o/O and enter
  autocmd("FileType", {
    command = "set formatoptions-=cro",
  })

  -- set winbar with breadcrumbs and file path
  autocmd({
    "CursorMoved",
    "BufWinEnter",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
  }, {
    callback = function()
      require("custom.ui.winbar").setup()
    end,
  })

  -- disable a few features for some filetypes
  autocmd("FileType", {
    pattern = {
      "nvdash",
      "packer",
      "*Telescope*",
      "terminal",
      "mason",
    },
    callback = function()
      -- disable ruler (aka virtual column)
      require("virt-column").setup_buffer({ virtcolumn = "" })

      -- disable quickscope highlight
      vim.b.qs_local_disable = 1
    end,
  })

  -- close neotree buffer before exitting (otherwise, it is buggy with autosession)
  autocmd({ "VimLeavePre" }, {
    callback = function()
      vim.cmd(":Neotree close")
    end,
  })

  -- sadly, git messenger is configured using global variables,
  -- and that's why this autocmd is necessary
  autocmd("FileType", {
    pattern = { "gitmessengerpopup" },
    callback = function()
      vim.g.git_messenger_always_into_popup = true
      vim.g.git_messenger_floating_win_opts = { border = "single" }
      vim.g.git_messenger_popup_content_margins = false
    end,
  })

  -- monitor all buffers to include into vim.t.bufs
  autocmd({ "BufAdd", "BufEnter", "tabnew" }, {
    callback = function(args)
      if vim.t.bufs == nil then
        vim.t.bufs = vim.api.nvim_get_current_buf() == args.buf and {} or { args.buf }
      else
        local bufs = vim.t.bufs

        -- check for duplicates
        if
            not vim.tbl_contains(bufs, args.buf)
            and (args.event == "BufEnter" or vim.bo[args.buf].buflisted)
            and (args.event == "BufEnter" or args.buf ~= vim.api.nvim_get_current_buf())
            and vim.api.nvim_buf_is_valid(args.buf)
            and vim.bo[args.buf].buflisted
        then
          table.insert(bufs, args.buf)

          -- remove unnamed buffer which isnt current buf & modified
          for index, bufnr in ipairs(bufs) do
            if
                #vim.api.nvim_buf_get_name(bufnr) == 0
                and (vim.api.nvim_get_current_buf() ~= bufnr or bufs[index + 1])
                and not vim.api.nvim_buf_get_option(bufnr, "modified")
            then
              table.remove(bufs, index)
            end
          end

          vim.t.bufs = bufs
        end
      end
    end,
  })

  -- monitor all buffer deletions to remove from vim.t.bufs
  autocmd("BufDelete", {
    callback = function(args)
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local bufs = vim.t[tab].bufs
        if bufs then
          for i, bufnr in ipairs(bufs) do
            if bufnr == args.buf then
              table.remove(bufs, i)
              vim.t[tab].bufs = bufs
              break
            end
          end
        end
      end
    end,
  })
end

-- Commands
M.setup_commands = function()
  local cmd = vim.api.nvim_create_user_command

  -- remove trailing spaces from current buffer
  cmd("RemoveTrailingSpace", function()
    vim.cmd([[%s/\s\+$//e]])
  end, {})

  -- yank current text selection on visual mode
  cmd("SearchForTextSelection", function()
    -- get selected text from visual mode
    vim.cmd('noau normal! "vy"')
    local text = vim.fn.getreg("v")

    -- run live_grep picker from telescope
    require("telescope.builtin").live_grep({
      prompt_title = "Search all",
      default_text = text,
    })
  end, {})

  -- close all opened buffers
  cmd("CloseAllBuffers", function()
    local neotree = require("neo-tree.command")
    -- must hide neo-tree before closing all buffers
    neotree.execute({ action = "close" })

    -- close all buffers
    vim.cmd("%bd!")

    -- show neo-tree again (filesystem is default option)
    neotree.execute({ action = "show" })
  end, {})

  -- wrap text at column X (or 100 if no arg is passed)
  -- TODO: implement this for range formatting, read this:
  -- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion
  cmd("WrapTextAtColumn", function(opts)
    local column = tonumber(opts.args) or 100
    vim.o.textwidth = column
    vim.api.nvim_feedkeys("gwap", "n", false)
  end, { nargs = "?" })

  -- go to next open buffer
  cmd("GoToNext", function()
    local bufs = M.bufilter() or {}

    for i, v in ipairs(bufs) do
      if vim.api.nvim_get_current_buf() == v then
        vim.cmd(i == #bufs and "b" .. bufs[1] or "b" .. bufs[i + 1])
        break
      end
    end
  end, {})

  -- go to previous open buffer
  cmd("GoToPrev", function()
    local bufs = M.bufilter() or {}

    for i, v in ipairs(bufs) do
      if vim.api.nvim_get_current_buf() == v then
        vim.cmd(i == 1 and "b" .. bufs[#bufs] or "b" .. bufs[i - 1])
        break
      end
    end
  end, {})

  -- close current buffer
  cmd("CloseCurrentBuffer", function()
    if vim.bo.buftype == "terminal" then
      vim.cmd(vim.bo.buflisted and "set nobl | enew" or "hide")
    else
      local bufnr = vim.api.nvim_get_current_buf()
      vim.cmd("GoToPrev")
      vim.cmd("confirm bd" .. bufnr)
    end
  end, {})

  -- TODO: create command for comment divider snippets
end

-- get a list of filtered buffers
M.bufilter = function()
  local bufs = vim.t.bufs or nil

  if not bufs then
    return {}
  end

  for i = #bufs, 1, -1 do
    if not vim.api.nvim_buf_is_valid(bufs[i]) and vim.bo[bufs[i]].buflisted then
      table.remove(bufs, i)
    end
  end

  return bufs
end

return M
