# thx claude
{ inputs, ... }:
{
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  flake.wrappers.hyprpaper =
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
          options.preload = lib.mkOption {
            default = [ ];
            type = lib.types.listOf lib.types.str;
          };
          options.wallpaper = lib.mkOption {
            default = [ ];
            type = lib.types.listOf (
              lib.types.submodule {
                freeformType = lib.types.attrsOf lib.types.str;
              }
            );
          };
          options.splash = lib.mkOption {
            default = false;
            type = lib.types.bool;
          };
          options.splash_offset = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.float;
          };
          options.ipc = lib.mkOption {
            default = true;
            type = lib.types.bool;
          };
        };
      };

      config.package = lib.mkDefault pkgs.hyprpaper;
      config.constructFiles.generatedConfig = {
        relPath = "${config.binName}-config.conf";
        content =
          let
            orderedFields = [
              "monitor"
              "path"
              "fit_mode"
            ];
            toVal =
              v:
              if lib.isBool v then
                (if v then "true" else "false")
              else if lib.isInt v || lib.isFloat v then
                toString v
              else
                v;
            wallpaperBlock =
              entry:
              let
                known = lib.filter (k: entry ? ${k}) orderedFields;
                rest = lib.attrNames (lib.removeAttrs entry orderedFields);
              in
              "wallpaper {\n"
              + lib.concatMapStrings (k: "    ${k} = ${toVal entry.${k}}\n") (known ++ rest)
              + "}";
            scalars = lib.concatStringsSep "\n" (
              lib.filter (s: s != "") [
                "splash = ${toVal config.settings.splash}"
                "ipc = ${if config.settings.ipc then "on" else "off"}"
                (lib.optionalString (
                  config.settings.splash_offset != null
                ) "splash_offset = ${toString config.settings.splash_offset}")
              ]
            );
          in
          lib.concatStringsSep "\n" (
            lib.filter (s: s != "") [
              scalars
              (lib.concatMapStringsSep "\n" (p: "preload = ${p}") config.settings.preload)
              (lib.concatStringsSep "\n" (map wallpaperBlock config.settings.wallpaper))
            ]
          )
          + "\n";
      };
      config.passthru.providedSessions = pkgs.hyprpaper.passthru.providedSessions;
      config.meta.platforms = lib.platforms.linux;
      config.appendFlag = [
        { data = "--config"; }
        { data = config.constructFiles.generatedConfig.path; }
      ];
      config.exePath = "bin/hyprpaper";
    };
}
