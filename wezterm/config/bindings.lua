local wezterm = require('wezterm')
local act = wezterm.action

-- Always close without confirmation
local function smart_close_pane(window, pane)
   window:perform_action(act.CloseCurrentPane({ confirm = false }), pane)
end

local function smart_close_tab(window, pane)
   window:perform_action(act.CloseCurrentTab({ confirm = false }), pane)
end

-- stylua: ignore
local keys = {

   -- ── Splits ───────────────────────────────────────────────────────
   -- Duplicate current pane
   { key = '\\',    mods = 'ALT',            action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
   { key = '-',     mods = 'ALT',            action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
   -- Duplicate current pane (shift variant)
   { key = '\\',    mods = 'ALT|SHIFT',      action = act.SplitPane({ direction = 'Right',  command = { args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l', '-i' } } }) },
   { key = '-',     mods = 'ALT|SHIFT',      action = act.SplitPane({ direction = 'Down',   command = { args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l', '-i' } } }) },
   -- Arch WSL splits
   { key = '\\',    mods = 'CTRL|ALT',       action = act.SplitPane({ direction = 'Right',  command = { domain = { DomainName = 'WSL:Arch' } } }) },
   { key = '-',     mods = 'CTRL|ALT',       action = act.SplitPane({ direction = 'Down',   command = { domain = { DomainName = 'WSL:Arch' } } }) },
   -- Duplicate active pane (like WT Alt+Shift+D)
   { key = 'd',     mods = 'ALT|SHIFT',      action = act.SplitPane({ direction = 'Right' }) },

   -- ── Pane focus ───────────────────────────────────────────────────
   { key = 'j',          mods = 'ALT',       action = act.ActivatePaneDirection('Down') },
   { key = 'k',          mods = 'ALT',       action = act.ActivatePaneDirection('Up') },
   { key = '[',          mods = 'ALT',       action = act.ActivatePaneDirection('Left') },
   { key = ']',          mods = 'ALT',       action = act.ActivatePaneDirection('Right') },
   { key = 'DownArrow',  mods = 'ALT',       action = act.ActivatePaneDirection('Down') },
   { key = 'UpArrow',    mods = 'ALT',       action = act.ActivatePaneDirection('Up') },
   { key = 'LeftArrow',  mods = 'ALT',       action = act.ActivatePaneDirection('Left') },
   { key = 'RightArrow', mods = 'ALT',       action = act.ActivatePaneDirection('Right') },

   -- ── Pane resize ──────────────────────────────────────────────────
   { key = 'h',     mods = 'ALT|SHIFT',      action = act.AdjustPaneSize({ 'Left',  3 }) },
   { key = 'j',     mods = 'ALT|SHIFT',      action = act.AdjustPaneSize({ 'Down',  3 }) },
   { key = 'k',     mods = 'ALT|SHIFT',      action = act.AdjustPaneSize({ 'Up',    3 }) },
   { key = 'l',     mods = 'ALT|SHIFT',      action = act.AdjustPaneSize({ 'Right', 3 }) },

   -- ── Close ────────────────────────────────────────────────────────
   { key = 'w',     mods = 'ALT',            action = wezterm.action_callback(smart_close_pane) },
   { key = 'q',     mods = 'ALT',            action = wezterm.action_callback(smart_close_tab) },
   { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },

   -- ── Tabs ─────────────────────────────────────────────────────────
   { key = 't',     mods = 'ALT',            action = act.SpawnTab('DefaultDomain') },
   { key = '1',     mods = 'ALT',            action = act.ActivateTab(0) },
   { key = '2',     mods = 'ALT',            action = act.ActivateTab(1) },
   { key = '3',     mods = 'ALT',            action = act.ActivateTab(2) },
   { key = '4',     mods = 'ALT',            action = act.ActivateTab(3) },
   { key = '5',     mods = 'ALT',            action = act.ActivateTab(4) },
   { key = '6',     mods = 'ALT',            action = act.ActivateTab(5) },
   { key = '7',     mods = 'ALT',            action = act.ActivateTab(6) },
   { key = '8',     mods = 'ALT',            action = act.ActivateTab(7) },
   { key = '9',     mods = 'ALT',            action = act.ActivateTab(8) },
   { key = ']',     mods = 'CTRL|SHIFT',     action = act.MoveTabRelative(1) },
   { key = '[',     mods = 'CTRL|SHIFT',     action = act.MoveTabRelative(-1) },
   { key = 'Tab', mods = 'CTRL', action = act.ShowTabNavigator },

   -- ── Scroll ───────────────────────────────────────────────────────
   { key = 'UpArrow',   mods = 'CTRL|SHIFT', action = act.ScrollByLine(-3) },
   { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(3) },
   { key = 'PageUp',    mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
   { key = 'PageDown',  mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },

   -- ── Copy / Paste ─────────────────────────────────────────────────
   { key = 'c',     mods = 'CTRL',           action = act.CopyTo('Clipboard') },
   { key = 'v',     mods = 'CTRL',           action = act.PasteFrom('Clipboard') },
   { key = 'f',     mods = 'CTRL|SHIFT',     action = act.Search({ CaseInSensitiveString = '' }) },

   -- ── Misc ─────────────────────────────────────────────────────────
   { key = 'F11',   mods = 'NONE',           action = act.ToggleFullScreen },
   { key = 'p',     mods = 'CTRL|SHIFT',     action = act.ActivateCommandPalette },
}

local mouse_bindings = {
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'ALT',
      action = act.StartWindowDrag,
   },

}

return {
   disable_default_key_bindings = true,
   keys = keys,
   mouse_bindings = mouse_bindings,
}
