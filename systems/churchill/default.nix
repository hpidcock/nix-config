{ inputs, ... }:
inputs.system-manager.lib.makeSystemConfig {
  modules = [
    inputs.nix-system-graphics.systemModules.default
    ../modules/chromium-sandbox.nix
    ./configuration.nix
  ];
  extraSpecialArgs = { inherit inputs; };
}
