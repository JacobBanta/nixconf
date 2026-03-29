{ self, inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      wrappers.control_type = "exclude";
      wrappers.packages.ghostty = true;

      packages.ghostty = self.wrappers.ghostty.wrap {
        inherit pkgs;
        settings = {
          command = "${lib.getExe pkgs.fish}";
        };
      };
    };
}
