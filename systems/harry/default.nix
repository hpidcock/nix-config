{ inputs, ... }:
inputs.system-manager.lib.makeSystemConfig {
  modules = [ 
    inputs.nix-system-graphics.systemModules.default
    ./configuration.nix
  ];
  extraSpecialArgs = { inherit inputs; };
}
