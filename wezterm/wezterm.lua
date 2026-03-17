local wezterm = require('wezterm')
local mux = wezterm.mux
local Config = require('config')

-- Maximize on startup (correct pattern from docs)
wezterm.on('gui-startup', function(cmd)
   local _, _, window = mux.spawn_window(cmd or {})
   window:gui_window():maximize()
end)

-- Set a single fixed wallpaper
require('utils.backdrops')
   :set_images()
   :set_img_by_name('frieren.jpeg')


return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
