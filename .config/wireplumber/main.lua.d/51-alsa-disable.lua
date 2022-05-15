-- INFO: Use 'wpctl' command to set default sink/source and volume for each one
rule_nvidia = {
    matches = {{{"device.name", "equals", "alsa_card.pci-0000_01_00.1"}}},
    apply_properties = {
        ["device.disabled"] = true
    }
}

rule_webcam_mic = {
    matches = {{{"device.name", "equals", "alsa_card.usb-046d_Logitech_Webcam_C925e_3E5E5DCF-02"}}},
    apply_properties = {
        ["device.disabled"] = true
    }
}

rule_dac_name = {
    matches = {{{"device.name", "equals", "alsa_card.usb-FX-AUDIO-DAC-X6_FX-AUDIO-DAC-X6-01"}}},
    apply_properties = {
        ["device.description"] = "DAC FX-AUDIO X6"
    }
}

-- rule_dac_input = {
--     matches = {{{"node.name", "equals", "alsa_input.usb-FX-AUDIO-DAC-X6_FX-AUDIO-DAC-X6-01.analog-stereo"}}},
--     apply_properties = {
--         ["node.disabled"] = true
--     }
-- }

table.insert(alsa_monitor.rules, rule_nvidia)
table.insert(alsa_monitor.rules, rule_webcam_mic)
table.insert(alsa_monitor.rules, rule_dac_name)
-- table.insert(alsa_monitor.rules, rule_dac_input)
