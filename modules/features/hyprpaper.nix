{ self, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      wrappers.control_type = "exclude";
      wrappers.packages.hyprpaper = true;

      packages.hyprpaper = self.wrappers.hyprpaper.wrap {
        inherit pkgs;
        settings = {
          splash = false;
          wallpaper = [
            {
              monitor = "";
              path = "${self}/wallpaper.png";
              fit_mode = "cover";
            }
          ];
        };
      };
    };
}
