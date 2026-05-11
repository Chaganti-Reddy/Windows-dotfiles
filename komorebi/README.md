\# Komorebi Windows Setup



Tiling window manager setup for Windows 11 using Komorebi + whkd, replicating an Arch Linux / Hyprland workflow.



\## Dependencies



\- \[komorebi](https://github.com/LGUG2Z/komorebi) — tiling window manager

\- \[whkd](https://github.com/LGUG2Z/whkd) — hotkey daemon

\- \[Iosevka Nerd Font](https://www.nerdfonts.com/) — bar font

\- Windows Terminal with Arch WSL2 as default profile



\## Install



```powershell

scoop bucket add extras

scoop install komorebi whkd

scoop bucket add nerd-fonts

scoop install nerd-fonts/Iosevka-NF

```



Set config locations:

```powershell

\[System.Environment]::SetEnvironmentVariable("KOMOREBI\_CONFIG\_HOME", "D:\\Git\\Windows-dotfiles\\komorebi", "User")

\[System.Environment]::SetEnvironmentVariable("WHKD\_CONFIG\_HOME", "D:\\Git\\Windows-dotfiles\\komorebi", "User")

```



Restart PowerShell after setting env variables, then verify:

```powershell

komorebic configuration   # should point to dotfiles

komorebic whkdrc          # should point to dotfiles

```



\## Start Manually



```powershell

komorebic start --whkd --bar

```



Stop:

```powershell

komorebic stop

```



\## Auto-start at Login



Run once in PowerShell (Admin):

```powershell

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-WindowStyle Hidden -Command `"komorebic start --whkd --bar`""

$trigger = New-ScheduledTaskTrigger -AtLogOn

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -TaskName "Komorebi" -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force

```



Remove auto-start:

```powershell

Unregister-ScheduledTask -TaskName "Komorebi" -Confirm:$false

```



\## Monitors



| Index | Display  | Resolution | Role |

|-------|----------|------------|------|

| 0     | DISPLAY2 | 1920x1080  | Main — 9 workspaces, bar |

| 1     | DISPLAY3 | 1920x1080  | Right external |

| 2     | DISPLAY1 | 1920x1200  | Laptop screen |



Monitors are auto-detected. When external monitors are disconnected, komorebi falls back to the laptop screen.



\## Files



| File | Purpose |

|------|---------|

| `komorebi.json` | Main WM config (layouts, gaps, borders, monitors) |

| `komorebi.bar.json` | Status bar (widgets, font, theme) |

| `whkdrc` | Keybindings |

| `applications.json` | Per-app tiling rules (float, ignore, tray) |



\## Keybinds



Modifier key is `Alt` (Super/Win opens Start menu on Windows).



\### Apps

| Keybind | Action |

|---------|--------|

| `Alt + Enter` | Windows Terminal (Arch WSL2) |

| `Alt + W` | Firefox Developer Edition |

| `Alt + Shift + W` | Firefox |

| `Alt + Shift + C` | VSCode |



\### Window Actions

| Keybind | Action |

|---------|--------|

| `Alt + Q` | Close window |

| `Alt + M` | Minimize window |

| `Alt + F` | Toggle monocle (fullscreen in layout) |

| `Alt + Shift + F` | Toggle float |

| `Alt + Shift + R` | Retile all windows |

| `Alt + P` | Pause/unpause tiling |

| `Alt + Shift + Enter` | Promote to master |



\### Focus

| Keybind | Action |

|---------|--------|

| `Alt + H` | Focus left |

| `Alt + J` | Focus down |

| `Alt + K` | Focus up |

| `Alt + L` | Focus right |



\### Move Windows

| Keybind | Action |

|---------|--------|

| `Alt + Shift + H` | Move window left |

| `Alt + Shift + J` | Move window down |

| `Alt + Shift + K` | Move window up |

| `Alt + Shift + L` | Move window right |



\### Resize

| Keybind | Action |

|---------|--------|

| `Alt + =` | Increase width |

| `Alt + -` | Decrease width |

| `Alt + Shift + =` | Increase height |

| `Alt + Shift + -` | Decrease height |



\### Layouts

| Keybind | Action |

|---------|--------|

| `Alt + X` | Flip layout horizontal |

| `Alt + Y` | Flip layout vertical |



\### Monitors

| Keybind | Action |

|---------|--------|

| `Alt + ,` | Focus previous monitor |

| `Alt + .` | Focus next monitor |

| `Alt + Shift + ,` | Move window to previous monitor |

| `Alt + Shift + .` | Move window to next monitor |



\### Workspaces

| Keybind | Action |

|---------|--------|

| `Alt + 1-9` | Switch to workspace |

| `Alt + Shift + 1-9` | Move window to workspace |



\### Config

| Keybind | Action |

|---------|--------|

| `Alt + O` | Reload whkd |

| `Alt + Shift + O` | Reload komorebi config |



\## Theme



Tokyo Night Dark (Base16)

