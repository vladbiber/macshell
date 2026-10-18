# Glue changes to MacShell

MacShell is by Rickky (@0-ss) and vSuol (@vsoultann), MIT licensed:
<https://github.com/0-ss/MacShell>. Glue keeps the upstream history and adds:

- a Glue mark as the default Menu Bar logo (Arch, Apple and custom stay in Settings)
- alacritty and nautilus as the default terminal and file manager
- Glue apps in the default Dock pins
- MacLock checks passwords with `/etc/pam.d/maclock` instead of hyprlock's
- the "Install dependencies" button is hidden when a package manages MacShell
  (`MACSHELL_MANAGED=1`), and the About page says it is packaged by Glue
- the Bluetooth tile in Control Center no longer reads `slot` from a scope it
  cannot see
- `glue/glue-macshell`, the launcher gluemac and gluewc start: it points
  MacShell at the compositor's Hyprland-compatible socket and its `hyprctl`
- helper scripts upstream expects but does not ship, in `glue/scripts`:
  video wallpapers through mpvpaper (with paused decoding when hidden) and
  Game Mode switching to the performance power profile; MacShell finds them
  through `MACSHELL_SCRIPTS`
- Sleep, Restart and Shut Down go through `loginctl` (elogind or systemd-logind),
  and Lock Screen runs `MACSHELL_LOCK_CMD` when it is set
- no Apple logo: the Menu Bar offers Glue, Arch or a custom image
