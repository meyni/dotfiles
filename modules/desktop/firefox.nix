{ config, lib, pkgs, ... }:
let
  cfg = config.buffet.desktop.firefox;
  sources = import ../../nix/sources.nix;
  nur = import sources.nur { inherit pkgs; };
in
with lib; {
  options = {
    buffet.desktop.firefox = {
      enable = mkEnableOption "firefox";
    };
  };

  config = mkIf cfg.enable {
    buffet.home = {
      home.sessionVariables = { BROWSER = "firefox"; };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;

        extensions = with nur.repos.rycee.firefox-addons; [
          darkreader
          https-everywhere
          reddit-moderator-toolbox
          ublock-origin
          vimium
        ];

        profiles = {
          default = {
            isDefault = true;
            id = 0;

            settings = {
              "browser.download.dir" = "/tmp/downloads";
              "browser.fullscreen.autohide" = false;
            };
          };
        };
      };
    };
  };
}