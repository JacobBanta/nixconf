{ inputs, ... }:
{
  imports = [ inputs.wrapper-modules.flakeModules.wrappers ];

  flake.wrappers.ghostty =
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
        type = lib.types.attrsOf lib.types.anything;
      };

      config.package = lib.mkDefault pkgs.ghostty;
      config.flagSeparator = "=";
      config.flags = lib.mapAttrs' (k: v: lib.nameValuePair "--${k}" (toString v)) config.settings;
      config.meta.platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
}
