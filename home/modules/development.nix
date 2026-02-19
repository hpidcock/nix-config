{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = [
    pkgs.gh
    pkgs.difftastic
    pkgs.ripgrep

    pkgs.podman-compose
    pkgs.skopeo
    pkgs.minikube
    pkgs.kubectl

    pkgs.awscli2
    pkgs.google-cloud-sdk
    pkgs.ssm-session-manager-plugin
  ];
}
