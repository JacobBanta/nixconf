{ self, inputs, ... }:
{
  flake.nixosConfigurations.framework13 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.framework13Configuration
    ];
  };
}
