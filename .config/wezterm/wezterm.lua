local wezterm = require('wezterm')

return {
    color_scheme = "TokyoNight (Gogh)",
    font = wezterm.font_with_fallback {
        "FiraCode Nerd Font Mono",
        "mononoki NFM"
    },
    harfbuzz_features = { 'zero' }
}
