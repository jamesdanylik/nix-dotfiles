{ pkgs, ... }: {
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      {
        timeout = 30;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
