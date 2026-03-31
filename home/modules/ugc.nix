{ pkgs, lib, ... }:
let
  ublockOrigin = pkgs.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26installsource%3Dondemand%26uc";
    hash = "sha256-FIbmYVj8cmXce7Vq4h7d2nOjmk4RkCnABmC4y5NDyGk=";
    name = "cjpalhdlnbpafiamejdnhcphjbkeiagm.crx";
  };
  _1password = pkgs.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3Daeblfdkhhhdcdjpifhhbdiojplfjncoa%26installsource%3Dondemand%26uc";
    hash = "sha256-k1Y+5hiWmnb6l8BIepT+MveK8QK7qQGQCZREj0+mt1w=";
    name = "aeblfdkhhhdcdjpifhhbdiojplfjncoa.crx";
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      {
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        crxPath = ublockOrigin;
        version = "1.70.0";
        updateUrl = "";
      }
      {
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
        crxPath = _1password;
        version = "8.12.8.26";
        updateUrl = "";
      }
    ];
    dictionaries = [
      pkgs.hunspellDictsChromium.en_GB
    ];
  };
}
