-- Matches all sources and sinks. This is necessary to avoid those "Broken pipe" errors
golden_rule = {
    matches = {{{"node.name", "matches", "alsa_input.*"}}, {{"node.name", "matches", "alsa_output.*"}}},
    apply_properties = {
        ["api.alsa.period-size"] = 256,
        ["api.alsa.headroom"] = 8192
    }
}

table.insert(alsa_monitor.rules, golden_rule)
