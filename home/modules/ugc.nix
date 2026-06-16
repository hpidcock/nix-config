{ pkgs, lib, ... }:
let
  ublockOrigin = pkgs.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3Dcjpalhdlnbpafiamejdnhcphjbkeiagm%26installsource%3Dondemand%26uc";
    hash = "sha256-VJ1fsew67rnYSg2Z8pqUlMtqYKjNA8Lmk6s5vqMyPBw=";
    name = "cjpalhdlnbpafiamejdnhcphjbkeiagm.crx";
  };
  _1password = pkgs.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3Daeblfdkhhhdcdjpifhhbdiojplfjncoa%26installsource%3Dondemand%26uc";
    hash = "sha256-6btg83FaHq2wlEqeypqDwQBTASpELilTAMJXjk52pks=";
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
        version = "1.71.0";
        updateUrl = "";
      }
      {
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
        crxPath = _1password;
        version = "8.12.22.17";
        updateUrl = "";
      }
    ];
    dictionaries = [
      pkgs.hunspellDictsChromium.en_GB
    ];
  };
}
