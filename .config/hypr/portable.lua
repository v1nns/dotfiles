-- Portable 16.1" monitor below primary (only plugged in occasionally)
-- Rules for an absent output are inert, so this is safe to always load and hotplug works
return function(hl, main_mod, move_to)
  local output = "HDMI-A-1"
  local serials = require("custom.monitors") -- private, lives in the utils repo

  -- Centered under primary (1920x1080 logical at 1.333333 scale)
  hl.monitor({
    output = output,
    mode = "2560x1440@144",
    position = "1400x1440",
    scale = 1.333333,
  })

  -- Monitor forgets its brightness on power cycle, so restore it over DDC/CI on hotplug
  -- (delay gives the monitor time to answer DDC after connecting)
  -- Capped at 50: on PC USB power it browns out and reboots above ~55; raise once on a PD charger
  hl.on("monitor.added", function(m)
    if m.name == output then
      hl.exec_cmd("sleep 3 && ddcutil --sn " .. serials.portable .. " setvcp 10 50")
    end
  end)

  for i = 1, 5 do
    local ws = 20 + i
    hl.workspace_rule({ workspace = tostring(ws), monitor = output, layout = "master" })
    hl.bind(main_mod .. " + ALT + " .. i, hl.dsp.focus({ workspace = ws }))
    hl.bind(main_mod .. " + ALT + SHIFT + " .. i, function()
      move_to(ws)
    end)
  end
end
