{
  pkgs,
  ...
}:
{
  imports = [
    ../modules/base.nix
    ../modules/desktop.nix
    ../modules/sway.nix
    ../modules/brave.nix
  ];

  home.packages = [
    pkgs.git
    pkgs.gh

    pkgs.firefox
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.discord

    pkgs.podman
  ];

  programs.ssh.matchBlocks."*" = {
    identityAgent = "~/.1password/agent.sock";
  };

  programs.git.settings.url = {
    "ssh://git@github.com/" = {
      insteadOf = "https://github.com/";
    };
  };

  home.stateVersion = "24.11";
}
