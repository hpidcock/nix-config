{
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.kernelPackages = pkgs.linuxPackages_6_14;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.amdgpu.amdvlk = {
    enable = true;
    support32Bit.enable = true;
  };

  networking.hostName = "nixon"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  security.pam.services.swaylock = { };
  security.polkit.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
  services.dbus = {
    enable = true;
    implementation = "broker";
  };
  services.greetd = {
    enable = true;
    restart = false;
    settings.default_session.command = ''
      ${lib.makeBinPath [ pkgs.greetd.tuigreet ]}/tuigreet -r --asterisks --time \
        --cmd sway-run
    '';
  };

  users.users.hpidcock = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "render"
      "audio"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ home-manager ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDeEbmFNlByddlrbMW9VPQiI7KlGe6znUhJtweFefexT9brmgHNKaSoD63bYqVjrVYf3lEdilPGFpnirSbpg1hZPqFrEKAoJbDFM9R7ObXgEVt7WqKl5WNgH1tNSChCCn8Hne6BUKeqP8MQOQo5HQFZSIglsRNfumGLCH9BLIojeXeivVgXtH5ekdqR+fK+HHVdHd5bT7NfQOvT9MFNBjdSRjVTTG9xtFFuJzYqZd9ZvbXBhTq3sEAkYkFnu2SfU5LdRr+UvDQ64e/erLCLh5zqn2mbsieNaKmA/Z/Yg6LmHAgeqDmyCTf4wOPjtONHWWFEAF9b8J+NbiVxD6kVM3g7gWcKz/N1Bttleh6/+QemlzuckpDdrwOUOisZXwUS5or0DY9sJLG2cFIZNz76zZuIRXW9PI3pIcOtTXjshslupyrrP1XMtNbDDu4VSuvEk3PrS6is6bi9M1v0BbnmPbTpyV4REeJUCtPli2m0anWhFKsHMQyG+MD5sZ36s/qeYb3kdjFvU6ljYY7vDAS3Ch6WOHEKv1eT3AfzS6EwOi6HTDZ8oucGh+DMWASF4jC0+nesAjYrlBLrpn3Eh56Krkv4nxLGpjC+VJKCFG3aeT7pjw9oUMbjZpeqmIICeG74Sg2iNwMuOVEYplMLNw8mgGxzbMT51VZhjmE/dNovm+Vt4Q== haza55@gmail.com"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];
  system.userActivationScripts = {
    home-manager-symlink = {
      text = ''
        test -h $HOME/.config/home-manager || (mkdir -p $HOME/.config && ln -s /etc/nixos $HOME/.config/home-manager)
      '';
    };
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # DO NOT CHANGE.
  system.stateVersion = "24.11";
}
