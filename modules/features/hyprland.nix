{ self, inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    {
      programs.hyprland.package = {
        inherit pkgs;
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      terminal = lib.getExe self'.packages.ghostty;
      mkHyprland =
        mod:
        self.wrappers.hyprland.wrap {
          inherit pkgs;
          settings = {
            monitor = [ ",preferred,auto,auto" ];

            env = [
              "XCURSOR_THEME,Adwaita"
              "XCURSOR_SIZE,24"
              "XCURSOR_PATH,${pkgs.adwaita-icon-theme}/share/icons"
              "XDG_DATA_DIRS,${pkgs.adwaita-icon-theme}/share"
            ];

            "exec-once" = [
              "${lib.getExe self'.packages.hyprpaper}"
            ];

            general = {
              gaps_in = 5;
              gaps_out = 10;
              border_size = 2;
              resize_on_border = false;
              allow_tearing = false;
              layout = "dwindle";
            };

            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 1.0;
              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };
              blur = {
                enabled = true;
                size = 3;
                passes = 1;
                vibrancy = 0.1696;
              };
            };

            animations = {
              enabled = false;
            };

            dwindle = {
              pseudotile = true;
              preserve_split = true;
            };

            master.new_status = "master";

            misc = {
              force_default_wallpaper = 1;
              disable_hyprland_logo = false;
            };

            input = {
              kb_layout = "us";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad.natural_scroll = false;
            };

            #gestures.workspace_swipe = false;

            bind = [
              "${mod}, Q, exec, ${terminal}"
              "${mod}, C, killactive"
              "${mod}, M, exit"
              "${mod}, V, togglefloating"
              "${mod}, R, exec, ${lib.getExe pkgs.hyprlauncher}"
              "${mod}, P, pseudo"
              "${mod}, J, togglesplit"

              "${mod}, left, movefocus, l"
              "${mod}, right, movefocus, r"
              "${mod}, up, movefocus, u"
              "${mod}, down, movefocus, d"

              "${mod}, 1, workspace, 1"
              "${mod}, 2, workspace, 2"
              "${mod}, 3, workspace, 3"
              "${mod}, 4, workspace, 4"
              "${mod}, 5, workspace, 5"
              "${mod}, 6, workspace, 6"
              "${mod}, 7, workspace, 7"
              "${mod}, 8, workspace, 8"
              "${mod}, 9, workspace, 9"
              "${mod}, 0, workspace, 10"

              "${mod} SHIFT, 1, movetoworkspace, 1"
              "${mod} SHIFT, 2, movetoworkspace, 2"
              "${mod} SHIFT, 3, movetoworkspace, 3"
              "${mod} SHIFT, 4, movetoworkspace, 4"
              "${mod} SHIFT, 5, movetoworkspace, 5"
              "${mod} SHIFT, 6, movetoworkspace, 6"
              "${mod} SHIFT, 7, movetoworkspace, 7"
              "${mod} SHIFT, 8, movetoworkspace, 8"
              "${mod} SHIFT, 9, movetoworkspace, 9"
              "${mod} SHIFT, 0, movetoworkspace, 10"

              "${mod}, S, togglespecialworkspace, magic"
              "${mod} SHIFT, S, movetoworkspace, special:magic"

              "${mod}, mouse_down, workspace, e+1"
              "${mod}, mouse_up, workspace, e-1"
            ];

            bindm = [
              "${mod}, mouse:272, movewindow"
              "${mod}, mouse:273, resizewindow"
            ];
          };
        };
    in
    {
      wrappers.control_type = "exclude";
      wrappers.packages.hyprland = true;

      packages.hyprland = mkHyprland "SUPER";
      packages.hyprlandNested = mkHyprland "ALT";
    };
}
