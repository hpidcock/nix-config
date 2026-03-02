{ pkgs, lib, ... }:
let
  ublockOrigin = pkgs.fetchurl {
    url = "https://github.com/gorhill/uBlock/releases/download/1.69.0/uBlock0_1.69.0.chromium.zip";
    hash = "sha256-N2IadpLk4y9bgGjNB5DPAtJhu7X0QK2RONBjBAxLF5c=";
    name = "cjpalhdlnbpafiamejdnhcphjbkeiagm.crx";
  };
  _1password = pkgs.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${lib.versions.major pkgs.ungoogled-chromium.version}&x=id%3Daeblfdkhhhdcdjpifhhbdiojplfjncoa%26installsource%3Dondemand%26uc";
    hash = "sha256-1zfV4LXZbrkssw1tvykSqUvyyg7dBEUWkaNqES8BAao=";
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
        version = "1.69.0";
        updateUrl = "";
      }
      {
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
        crxPath = _1password;
        version = "8.12.4.46";
        updateUrl = "";
      }
    ];
    dictionaries = [
      pkgs.hunspellDictsChromium.en_GB
    ];
  };
}
