alsa_monitor.enabled = true

-- INFO: Use 'wpctl' command to set default sink/source and volume for each one
rule_hdmi = {
    matches = {{{"node.nick", "matches", "HDMI*"}}},
    apply_properties = {
        ["node.disabled"] = true
    }
}

rule_webcam_mic = {
    matches = {{{"device.name", "equals", "alsa_card.usb-046d_Logitech_Webcam_C925e_3E5E5DCF-02"}}},
    apply_properties = {
        ["device.disabled"] = true
    }
}

table.insert(alsa_monitor.rules, rule_hdmi)
table.insert(alsa_monitor.rules, rule_webcam_mic)
table.insert(alsa_monitor.rules, rule_dac_name)
