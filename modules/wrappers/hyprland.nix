# thx claude
{ inputs, ... }:
{
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  flake.wrappers.hyprland =
    {
      pkgs,
      wlib,
      lib,
      config,
      ...
    }:
    {
      imports = [ wlib.modules.default ];

      options.settings = lib.mkOption {
        default = { };
        type = lib.types.submodule {
          freeformType = lib.types.attrs;
          options =
            lib.genAttrs
              [
                "bind"
                "binde"
                "bindr"
                "bindl"
                "bindm"
                "exec-once"
                "exec-shutdown"
                "monitor"
                "env"
                "windowrulev2"
                "layerrule"
                "workspace"
              ]
              (
                key:
                lib.mkOption {
                  default = [ ];
                  type = lib.types.listOf lib.types.str;
                }
              );
        };
      };

      config.package = lib.mkDefault pkgs.hyprland;
      config.extraPackages = [ pkgs.adwaita-icon-theme ];
      config.constructFiles.generatedConfig = {
        relPath = "${config.binName}-config.conf";
        content =
          let
            repeatedKeys = [
              "bind"
              "binde"
              "bindr"
              "bindl"
              "bindm"
              "exec-once"
              "exec-shutdown"
              "monitor"
              "env"
              "windowrulev2"
              "layerrule"
              "workspace"
            ];
            leftpad = s: lib.concatMapStrings (l: "    ${l}\n") (lib.splitString "\n" s);
            toVal =
              v:
              if lib.isBool v then
                (if v then "true" else "false")
              else if lib.isInt v || lib.isFloat v then
                toString v
              else
                v;
            mkKeyVal =
              k: v:
              if lib.isList v then
                lib.concatMapStringsSep "\n" (item: "${k} = ${toVal item}") v
              else
                "${k} = ${toVal v}";
            attrsToHyprlang =
              a:
              lib.concatStringsSep "\n" (
                lib.mapAttrsToList (
                  n: v: if lib.isAttrs v then "${n} {\n${leftpad (attrsToHyprlang v)}}" else mkKeyVal n v
                ) a
              );
          in
          lib.strings.concatLines (
            lib.lists.flatten [
              (map (k: map (v: "${k} = ${v}") config.settings.${k}) repeatedKeys)
              (attrsToHyprlang (lib.removeAttrs config.settings (repeatedKeys ++ [ "extraConfig" ])))
              (config.settings.extraConfig or "")
            ]
          );
      };
      config.passthru.providedSessions = pkgs.hyprland.passthru.providedSessions;
      config.meta.platforms = lib.platforms.linux;
      config.appendFlag = [
        { data = "--"; }
        { data = "--config"; }
        { data = config.constructFiles.generatedConfig.path; }
      ];
      config.exePath = "bin/start-hyprland";
    };
}
