local backdrops = require('utils.backdrops')
local colors = require('colors.custom')

return {
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',

   -- cursor
   animation_fps = 1,
   default_cursor_style = 'BlinkingBar',
   cursor_blink_rate = 500,
   animation_fps = 60,

   -- colors
   colors = colors,

   -- background with wallpaper + dark overlay (acrylic-like effect)
   background = backdrops:initial_options(false),

   -- scrollbar
   enable_scroll_bar = false,

   -- tab bar — default fancy tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   use_fancy_tab_bar = false,
   tab_bar_at_bottom = true,
   switch_to_last_active_tab_when_closing_tab = true,

   -- window
   window_padding = {
      left = 6,
      right = 6,
      top = 8,
      bottom = 4,
   },
   adjust_window_size_when_changing_font_size = false,
   window_close_confirmation = 'NeverPrompt',
   window_decorations = 'TITLE | RESIZE',
   window_frame = {
      active_titlebar_bg = '#11111b',
   },
   inactive_pane_hsb = {
      saturation = 0.85,
      brightness = 0.65,
   },
}
