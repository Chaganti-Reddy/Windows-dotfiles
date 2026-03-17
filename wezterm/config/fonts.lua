local wezterm = require('wezterm')

return {
   font = wezterm.font({
      family = 'Iosevka NF Medium',
      weight = 'Medium',
   }),
   font_size = 12,
   freetype_load_target = 'Normal',
   freetype_render_target = 'Normal',
}
