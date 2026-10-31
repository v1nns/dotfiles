-- SYSC-Greet Hyprland config for greetd greeter session

--------------------
---- MONITORS ----
--------------------

-- Explicit order ensures workspace 1 is always created on DP-3
hl.monitor({ output = "DP-3", mode = "preferred", position = "0x0", scale = 1 })
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1 })
hl.monitor({ output = "DP-2", disabled = true })

---------------------
---- BASE CONFIG ----
---------------------

hl.config({
  animations = { enabled = false },

  decoration = {
    rounding = 0,
    blur = { enabled = false },
  },

  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    background_color = "rgb(000000)",
    disable_watchdog_warning = true,
  },

  ecosystem = {
    no_update_news = true,
    no_donation_nag = true,
  },

  input = {
    kb_layout = "us",
    repeat_delay = 400,
    repeat_rate = 40,
    touchpad = { tap_to_click = true },
  },
})

---------------------
---- WORKSPACE ----
---------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-3", default = true })

-----------------------
---- WINDOW RULES ----
-----------------------

hl.window_rule({
  name = "kitty-greeter",
  match = { class = "^(kitty)$" },
  fullscreen = true,
  opacity = 1.0,
})

hl.layer_rule({
  name = "wallpaper-blur",
  match = { namespace = "wallpaper" },
  blur = true,
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd(
    "gslapper -f -I /tmp/sysc-greet-wallpaper.sock '*' /usr/share/sysc-greet/wallpapers/sysc-greet-default.png"
  )
  hl.exec_cmd(
    "XDG_CACHE_HOME=/var/lib/greeter/.cache HOME=/var/lib/greeter kitty --start-as=fullscreen --config=/etc/greetd/kitty.conf /usr/local/bin/sysc-greet && hyprctl dispatch 'hl.dsp.exit()'"
  )
end)
