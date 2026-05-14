-- Author: Vinicius M. Longaray
--
-- Check for more info: https://wiki.hyprland.org/Configuring/
--

--------------------
---- MONITORS ----
--------------------

-- Define output monitors
local primary = "DP-3"
local secondary = "DP-2"

hl.monitor({
  output = primary,
  mode = "2560x1440@240",
  position = "1080x0",
  scale = 1,
})

hl.monitor({
  output = secondary,
  mode = "preferred",
  position = "0x0",
  scale = 1,
  transform = 1,
})

-- hl.monitor({ output = "", mode = "highrr", position = "auto", scale = 1 }) -- auto find monitor

---------------------
---- BASE CONFIG ----
---------------------

hl.config({
  xwayland = {
    force_zero_scaling = true,
    use_nearest_neighbor = false,
    enabled = true,
  },

  debug = {
    disable_logs = true,
  },

  ecosystem = {
    no_update_news = true,
  },

  cursor = {
    no_hardware_cursors = true,
  },
})

-------------------
---- PLUGINS ----
-------------------

hl.config({
  plugin = {
    -- easymotion = {
    --   textsize = 45,
    --   textcolor = "rgba(ffffffff)",
    --   bgcolor = "rgba(000000ff)",
    --   bordersize = 50,
    --   bordercolor = "rgba(000000ff)",
    --   textfont = "JetBrainsMono NF",
    -- },
  },
})

------------------------
---- EVENT HANDLING ----
------------------------

-- Execute initial programs once on startup (exec-once equivalent)
hl.on("hyprland.start", function()
  hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/startup.sh")
  hl.exec_cmd("kitty --title dropdown-terminal -e zsh -o 'ignoreeof'")
  hl.exec_cmd("vicinae server")
  hl.exec_cmd("waybar")
end)

-- Execute programs on every config reload (exec equivalent)
hl.on("config.reloaded", function()
  hl.exec_cmd("pkill waybar; waybar")
end)

-- Resize and center the dropdown on whichever monitor is active when toggled
local dropdown_w_pct = 0.5
local dropdown_h_pct = 0.5

hl.on("window.active", function(w)
  if w.workspace == nil or w.workspace.name ~= "special:dropdown" then
    return
  end

  local mon = hl.get_active_monitor()
  if mon == nil then
    return
  end

  local new_w = math.floor((mon.width / mon.scale) * dropdown_w_pct)
  local new_h = math.floor((mon.height / mon.scale) * dropdown_h_pct)

  hl.dispatch(hl.dsp.window.resize({ x = new_w, y = new_h, window = w }))
  hl.dispatch(hl.dsp.window.center({ window = w }))
end)

-- Map window class+title -> workspace name
local class_names = {
  { class = "firefox", name = "web" },
  { class = "obsidian", name = "notes" },
  { class = "ffplay", title = "rtsp", name = "camera" },
}

local function match_window_name(w)
  for _, rule in ipairs(class_names) do
    local class_ok = rule.class == nil or w.class:match(rule.class)
    local title_ok = rule.title == nil or w.title:match(rule.title)
    if class_ok and title_ok then
      return rule.name
    end
  end
  return nil
end

local function auto_rename_workspace(w)
  -- skip any scratchpads
  if w == nil or w.workspace == nil or w.workspace.name:match("^special:") then
    return
  end

  local name = match_window_name(w)
  if name == nil then
    return
  end

  -- Only rename if workspace has no custom name yet
  local current = w.workspace.name:match("^%d+:(.+)$")
  if current ~= nil then
    return
  end

  hl.dispatch(hl.dsp.workspace.rename({
    workspace = w.workspace.id,
    name = tostring(w.workspace.id) .. ":" .. name,
  }))
end

hl.on("window.open", auto_rename_workspace)
hl.on("window.move_to_workspace", auto_rename_workspace)

--------------------------
---- DEFAULT PROGRAMS ----
--------------------------

local terminal = "kitty"
local file_manager = "nemo"
local launcher = "vicinae toggle"

local work_mode = os.getenv("HOME") .. "/.local/bin/work-mode.sh"

------------------------------
---- ENVIRONMENT VARIABLES ----
------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- Check info from https://wiki.hyprland.org/Configuring/Multi-GPU
hl.env("WLR_DRM_DEVICES", "/dev/dri/card0:/dev/dri/card1")

---------------
---- INPUT ----
---------------

hl.config({
  input = {
    --kb_layout  = "br",
    --kb_variant = "abnt2",
    kb_layout = "us",
    kb_variant = "intl",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = 1,
    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = false,
    },
  },
})

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 5,

    border_size = 2,

    col = {
      -- active_border   = { colors = {"rgba(7aa2f7ee)", "rgba(907af7ee)"}, angle = 45 },
      active_border = { colors = { "rgba(73dacaee)", "rgba(bb9af7ee)" }, angle = 90 },
      inactive_border = "rgba(595959aa)",
    },

    layout = "dwindle",

    allow_tearing = false,
    resize_on_border = true,
    no_focus_fallback = true,
  },

  decoration = {
    rounding = 10,

    blur = {
      enabled = false,
      size = 1,
      passes = 1,
      new_optimizations = true,
      xray = true,
      ignore_opacity = true,
      noise = 0.3,
      brightness = 0.90,
    },

    shadow = {
      enabled = true,
      range = 12,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
    -- smart_split = true,
    use_active_for_splits = false,
  },

  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    enable_swallow = true,
    swallow_regex = "^(kitty)$",
    initial_workspace_tracking = 0,
  },
})

-- Animation curves
-- See https://wiki.hyprland.org/Configuring/Advanced-and-Cool/Animations/
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("fluent_decel", { type = "bezier", points = { { 0, 0.2 }, { 0.4, 1 } } })

-- Animation effects
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "md3_decel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "fluent_decel" })
hl.animation({ leaf = "fadeLayersIn", enabled = false })
hl.animation({
  leaf = "workspaces",
  enabled = true,
  speed = 3,
  bezier = "fluent_decel",
  style = "slidefade 30%",
})
hl.animation({
  leaf = "specialWorkspace",
  enabled = true,
  speed = 2,
  bezier = "fluent_decel",
  style = "slidefadevert 10%",
})

---------------------------------
---- WORKSPACE & WINDOW RULES ----
---------------------------------

-- Setup all workspaces
for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), monitor = primary })
end
for i = 11, 20 do
  hl.workspace_rule({ workspace = tostring(i), monitor = secondary })
end

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
  name = "no-gaps-wtv1",
  match = { float = false, workspace = "w[tv1]" },
  border_size = 0,
  rounding = 0,
})
hl.window_rule({
  name = "no-gaps-f1",
  match = { float = false, workspace = "f[1]" },
  border_size = 0,
  rounding = 0,
})

-- Dropdown terminal
hl.window_rule({
  name = "dropdown",
  match = { class = "^(kitty)$", title = "^(dropdown-terminal)$" },
  float = true,
  workspace = "special:dropdown silent",
  stay_focused = true,
})

-- Volume control
hl.window_rule({
  name = "volume-control",
  match = { class = "^(pavucontrol)$" },
  float = true,
  size = { "monitor_w * 0.6", "monitor_h * 0.6" },
  center = true,
})

-- RTSP streams from ffplay
hl.window_rule({
  name = "ffplay",
  match = { class = "^(ffplay)$", title = "(.*rtsp.*)" },
  workspace = "10",
  focus_on_activate = true,
})


--------------------------
---- CUSTOM FUNCTIONS ----
--------------------------

local ROFI_THEME_DIR = os.getenv("HOME") .. "/.config/rofi/tokyo"

-- Custom command helpers
local function is_dropdown()
  local w = hl.get_active_window()
  return w ~= nil and w.title == "dropdown-terminal"
end

local function killactive()
  if not is_dropdown() then
    hl.dispatch(hl.dsp.window.close())
  end
end

local function set_fullscreen()
  if is_dropdown() then
    hl.dispatch(hl.dsp.window.fullscreen({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
  else
    hl.dispatch(hl.dsp.window.fullscreen_state({ internal = 1, client = 2, action = "toggle" }))
  end
end

-- Rename the active workspace interactively via rofi, or apply a preset name.
-- preset_name: if provided, rename silently (only if workspace is still unnamed).
-- Without preset_name, opens rofi pre-filled with the current name so the user
-- can edit it; an empty submission resets the name back to just the numeric ID.
local function rename_workspace(preset_name)
  -- Ignore when the dropdown terminal is the focused window
  local win = hl.get_active_window()
  if win ~= nil and win.workspace.name == "special:dropdown" then
    return
  end

  local ws = hl.get_active_workspace()
  if(ws == nil) then
    return
  end

  local id = ws.id
  local name = (ws.name:match("^%d+:(.+)$") or ""):match("^%s*(.-)%s*$")

  local output
  if preset_name ~= nil then
    if name ~= "" then
      return
    end -- already named, skip silently
    output = preset_name
  else
    -- Run rofi asynchronously to avoid blocking Hyprland's compositor thread.
    -- Dynamic values (id, name, theme dir) are passed as env vars so the
    -- bash -c script stays static and no quoting gymnastics are needed.
    -- hyprctl dispatch expects a Lua expression (not positional args).
    local safe_name = "'" .. name:gsub("'", "'\\''") .. "'"
    local safe_theme = "'" .. ROFI_THEME_DIR:gsub("'", "'\\''") .. "'"
    os.execute(
      string.format(
        "WSID=%d WSFILTER=%s WSTHEME=%s bash -c '"
          .. 'output=$(rofi -theme "$WSTHEME/renameworkspace.rasi" -dmenu -lines 0 -p "Rename workspace:" -filter "$WSFILTER"); '
          .. "[ $? -ne 0 ] && exit 0; "
          .. 'if [ -z "$output" ]; then '
          .. 'hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $WSID, name = \\"$WSID\\" })"; '
          .. "else "
          .. 'hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $WSID, name = \\"$WSID:$output\\" })"; '
          .. "fi' &",
        id,
        safe_name,
        safe_theme
      )
    )
    return
  end

  if output == "" then
    hl.dispatch(hl.dsp.workspace.rename({ workspace = id, name = tostring(id) }))
  else
    hl.dispatch(hl.dsp.workspace.rename({ workspace = id, name = tostring(id) .. ":" .. output }))
  end
end

-- Move active window to a specific workspace.
-- If the source workspace had a custom name and the window was the only one there,
-- carry that name over to the target workspace (unless it already has a custom name)
local function move_to(target)
  local old_ws = hl.get_active_workspace()
  if old_ws == nil then
    return
  end

  -- Snapshot all values before any dispatch: old_ws may be a live proxy and
  -- fields like .windows can change once the move executes.
  local win_count = old_ws.windows
  local custom_name = old_ws.name:match("^%d+:(.+)$")
  local target_ws = hl.get_workspace(tostring(target))
  local target_custom = target_ws and target_ws.name:match("^%d+:(.+)$")

  hl.dispatch(hl.dsp.window.move({ workspace = target }))

  if custom_name and win_count == 1 and not target_custom then
    hl.dispatch(hl.dsp.workspace.rename({
      workspace = tostring(target),
      name = tostring(target) .. ":" .. custom_name,
    }))
  end
end

-- Move active window to the next empty workspace, carrying the name as above
local function move_to_empty()
  local old_ws = hl.get_active_workspace()
  if old_ws == nil then
    return
  end

  -- Snapshot before any dispatch (same live-proxy concern as move_to).
  local win_count = old_ws.windows
  local old_id = old_ws.id
  local custom_name = old_ws.name:match("^%d+:(.+)$")

  -- Pre-compute the target empty workspace ID so we don't need to query state
  -- after the dispatch (which may not have resolved yet).
  local empty_id
  if custom_name and win_count == 1 then
    for i = 1, 100 do
      if i ~= old_id then
        local ws = hl.get_workspace(tostring(i))
        if ws == nil or ws.windows == 0 then
          empty_id = i
          break
        end
      end
    end
  end

  hl.dispatch(hl.dsp.window.move({ workspace = "empty" }))

  if empty_id then
    hl.dispatch(hl.dsp.workspace.rename({
      workspace = empty_id,
      name = tostring(empty_id) .. ":" .. custom_name,
    }))
  end
end

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- General binds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", killactive)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + U", function()
  rename_workspace()
end)
hl.bind(mainMod .. " + F", set_fullscreen)
hl.bind(mainMod .. " + Y", hl.dsp.layout("togglesplit"))
-- hl.bind(mainMod .. " + TAB",      hl.dsp.exec_cmd(window_picker))
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("dropdown"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(work_mode))
hl.bind(mainMod .. " + O", function()
  rename_workspace("notes")
  hl.dispatch(hl.dsp.exec_cmd("obsidian"))
end)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "d" }))

-- Move active window to a direction
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
  hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Switch workspaces with mainMod + CTRL + [0-9] (secondary monitor)
for i = 1, 9 do
  hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.focus({ workspace = 10 + i }))
end
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.focus({ workspace = 20 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 9 do
  hl.bind(mainMod .. " + SHIFT + " .. i, function()
    move_to(i)
  end)
end
hl.bind(mainMod .. " + SHIFT + 0", function()
  move_to(10)
end)

-- Move active window to a workspace with mainMod + CTRL + SHIFT + [0-9]
for i = 1, 9 do
  hl.bind(mainMod .. " + CTRL + SHIFT + " .. i, function()
    move_to(10 + i)
  end)
end
hl.bind(mainMod .. " + CTRL + SHIFT + 0", function()
  move_to(20)
end)

-- Move active window to next empty workspace
hl.bind(mainMod .. " + SHIFT + T", move_to_empty)

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Dunst notifications
hl.bind("CTRL + Space", hl.dsp.exec_cmd("dunstctl close"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("dunstctl history-pop"))

-- Media control
hl.bind(
  "XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"),
  { repeating = true }
)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"))

-- TODO: play stuff
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("spotify_ctl.py --toggle-play"))
-- hl.bind("XF86AudioStop", hl.dsp.exec_cmd("spotify_ctl.py --stop"))
-- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("spotify_ctl.py --previous"))
-- hl.bind("XF86AudioNext", hl.dsp.exec_cmd("spotify_ctl.py --next"))

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

-- Screenshot
hl.bind(
  "Print",
  hl.dsp.exec_cmd(
    "grim -o "
      .. primary
      .. ' $(xdg-user-dir PICTURES)/$(date +\'%s_grim.png\'); notify-send "INFO 🧐" "Took a screenshot from primary monitor"'
  )
)
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd('wl-copy < <(grim -g "$(slurp)" -)'))
hl.bind(
  mainMod .. " + SHIFT + Print",
  hl.dsp.exec_cmd(
    "grim -o "
      .. secondary
      .. ' $(xdg-user-dir PICTURES)/$(date +\'%s_grim.png\'); notify-send "INFO 🧐" "Took a screenshot from secondary monitor"'
  )
)

-- Submap to resize window
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
  hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
  hl.bind("escape", hl.dsp.submap("reset"))
end)

-- google-chrome settings (for future reference)
-- --password-store=gnome-libsecret --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WaylandPerSurfaceScale,WaylandUiScale --gtk-version=4 --force-device-scale-factor=1
