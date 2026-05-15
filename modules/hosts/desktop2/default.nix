{ self, inputs, ... }:
{
  flake.nixosConfigurations.desktop2 = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktop2Configuration
      self.nixosModules.ly
    ];
  };
}
