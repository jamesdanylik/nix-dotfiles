{ pkgs, ... }: {
  home.packages = [ pkgs.nwg-bar ];
  xdg.configFile."nwg-bar/bar.json".text = ''
    [
     {
       "label": "Lock",
       "exec": "",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-lock-screen.svg"
     },
     {
       "label": "Logout",
       "exec": "hyprctl dispatch exit",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-log-out.svg"
     },
     {
       "label": "Reboot",
       "exec": "systemctl reboot",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg"
     },
     {
       "label": "Shutdown",
       "exec": "systemctl -i poweroff",
       "icon": "${pkgs.nwg-bar}/share/nwg-bar/images/system-shutdown.svg"
     }
    ]
  '';
}
