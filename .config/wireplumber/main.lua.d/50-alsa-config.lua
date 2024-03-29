alsa_monitor.enabled = true

-- Matches all sources and sinks. This is necessary to avoid "Broken pipe" errors
golden_rule = {
    matches = {{{"node.name", "matches", "alsa_input.*"}}, {{"node.name", "matches", "alsa_output.*"}}},
    apply_properties = {
        -- ["api.alsa.period-size"] = 256,
        -- ["api.alsa.headroom"] = 2048
        ["api.alsa.period-size"] = 1024,
        ["api.alsa.headroom"] = 8192
    }
}

--  Matches all sources and sinks except Built-in audio. This is necessary to avoid
-- "spa.alsa: hw:X,0: Channels doesn't match (requested 64, got 2)" errors
fix_channels = {
    matches = {{{"node.name", "not-equals", "alsa_input.pci-0000_00_1f.3.capture.*"}},
               {{"node.name", "not-equals", "alsa_output.pci-0000_00_1f.3.playback.*"}}},
    apply_properties = {
        ["audio.channels"] = 2
    }
}

-- Change DAC name
rename_dac = {
    matches = {{{"device.name", "equals", "alsa_card.usb-FX-AUDIO-DAC-X6_FX-AUDIO-DAC-X6-01"}}},
    apply_properties = {
        ["device.description"] = "DAC FX-AUDIO X6"
    }
}

-- This rule is to instantly use DAC right after connected
switch_to_dac = {
    matches = {{{"node.name", "matches",
                 "alsa_output.usb-GuangZhou_FiiO_Electronics_Co._Ltd_FiiO_K5_Pro-00.playback.0.0"}}},
    apply_properties = {
        ["priority.session"] = 1000,
        ["audio.rate"] = 96000
    }
}

-- This rule is to instantly use bluetooth device right after paired/connected
switch_to_bt = {
    matches = {{{"node.name", "matches", "bluez_output*"}}},
    apply_properties = {
        ["priority.session"] = 1010
    }
}

table.insert(alsa_monitor.rules, golden_rule)
table.insert(alsa_monitor.rules, fix_channels)
table.insert(alsa_monitor.rules, rename_dac)
table.insert(alsa_monitor.rules, switch_to_dac)
table.insert(alsa_monitor.rules, switch_to_bt)
