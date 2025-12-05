{
  pkgs,
  ...
}:
{
  imports = [
    ../../desktop/alacritty.nix
    ../../desktop/sway.nix
    ../../desktop/zsh.nix
    ../../desktop/zed.nix
  ];

  home.username = "hpidcock";
  home.homeDirectory = "/home/hpidcock";
  home.sessionVariables = {
    EDITOR = "vim";
    PATH = "/home/hpidcock/go/bin:$PATH";
  };
  home.language = {
    base = "en_AU.utf8";
  };
  fonts.fontconfig = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-rofi;
  };

  home.packages = [
    pkgs.vim
    pkgs.gh
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.gnupg
    pkgs.pinentry-rofi
    pkgs.difftastic
    pkgs.ripgrep
    pkgs.ollama
    pkgs.mpv

    pkgs.librewolf
    pkgs.firefox
    pkgs.standardnotes
    pkgs.spotify
    pkgs._1password-gui
    pkgs.signal-desktop
    pkgs.element-desktop
    pkgs.high-tide

    pkgs.podman
    pkgs.podman-compose
    pkgs.skopeo
    pkgs.minikube
    pkgs.kubectl
    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.ssm-session-manager-plugin
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
        IdentityAgent "~/.1password/agent.sock"
    '';
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Harry Pidcock";
    userEmail = "harry.pidcock@canonical.com";
    signing = {
      signByDefault = true;
      key = "C80B31F3A3B03C28C9ACAFFB89E735F9C1156A58";
    };
    extraConfig.url = {
      "git+ssh://git.launchpad.net/" = {
        insteadOf = "lp:";
      };
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
    ignores = [
      ".envrc"
      ".direnv/"
    ];
  };

  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1password
    ];
  };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
