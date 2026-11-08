-- Equal-share stacking layout for the vertical secondary monitor
-- Messages: "orientationcycle" (rows <-> columns, Super+Y) and
-- "resize <dx> <dy>" (sent by the resize submap in hyprland.lua)
return function(hl)
  local use_columns = {}
  local function layout_workspace_id(ctx)
    local target = ctx.targets[1]
    return target and target.window and target.window.workspace.id
  end
  -- Relative size of each window (by stable_id), changed from the resize submap
  local size_weights = {}
  local function weight(target)
    return target.window and size_weights[target.window.stable_id] or 1
  end
  hl.layout.register("rows", {
    recalculate = function(ctx)
      local columns = use_columns[layout_workspace_id(ctx)]
      local area = ctx.area
      local total = 0
      for _, target in ipairs(ctx.targets) do
        total = total + weight(target)
      end
      local offset = 0
      for _, target in ipairs(ctx.targets) do
        local share = weight(target) / total
        if columns then
          target:place({ x = area.x + offset, y = area.y, w = area.w * share, h = area.h })
          offset = offset + area.w * share
        else
          target:place({ x = area.x, y = area.y + offset, w = area.w, h = area.h * share })
          offset = offset + area.h * share
        end
      end
    end,
    layout_msg = function(ctx, msg)
      local id = layout_workspace_id(ctx)
      if id and msg:match("^orientationcycle") then
        use_columns[id] = not use_columns[id]
        return true
      end
      -- "resize <dx> <dy>": grow/shrink the active window along the stacking axis
      local dx, dy = msg:match("^resize (%S+) (%S+)$")
      local active = hl.get_active_window()
      if dx and active then
        local delta = use_columns[id] and tonumber(dx) or tonumber(dy)
        local span = use_columns[id] and ctx.area.w or ctx.area.h
        local total = 0
        for _, target in ipairs(ctx.targets) do
          total = total + weight(target)
        end
        -- Pick the weight that makes the window's share grow by exactly delta pixels
        local key = active.stable_id
        local current = size_weights[key] or 1
        local others = total - current
        local share = math.min(0.95, math.max(0.05, current / total + delta / span))
        size_weights[key] = others > 0 and share * others / (1 - share) or 1
        return true
      end
      return false
    end,
  })
  return "lua:rows"
end
