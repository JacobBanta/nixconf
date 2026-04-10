{ self, inputs, ... }:
{
  flake.nixosModules.ly =
    { pkgs, lib, ... }:
    let
      launchComp = pkgs.writeShellScript "launch-mycomp" ''
        exec nix run github:jacobbanta/nixconf#hyprland
      '';
    in
    {
      services.displayManager.ly.enable = true;
      services.displayManager.ly.settings = {
        waylandsessions = "/etc/wayland-sessions";
      };

      environment.etc."wayland-sessions/hyprland.desktop".text = ''
        [Desktop Entry]
        Name=Better than Niri
        Exec=${launchComp}
        Type=Application
      '';
    };
}
