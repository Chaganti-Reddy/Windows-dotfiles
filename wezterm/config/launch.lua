return {
   default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l', '-i' },
   launch_menu = {
      { label = 'Git Bash',         args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l', '-i' } },
      { label = 'Arch WSL',         args = { 'wsl.exe', '-d', 'Arch' } },
      { label = 'PowerShell Core',  args = { 'pwsh', '-NoLogo' } },
      { label = 'PowerShell',       args = { 'powershell' } },
      { label = 'Command Prompt',   args = { 'cmd' } },
   },
}
