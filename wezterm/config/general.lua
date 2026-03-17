return {
   automatically_reload_config = true,
   exit_behavior = 'CloseOnCleanExit',
   audible_bell = 'Disabled',
   scrollback_lines = 5000,
   -- Kill window AND tab close dialogs entirely
   window_close_confirmation = 'NeverPrompt',
   -- Skip dialog when only shells are running in pane
   skip_close_confirmation_for_processes_named = {
      'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu',
      'cmd.exe', 'pwsh.exe', 'powershell.exe', 'wsl.exe',
   },
}
