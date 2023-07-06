{ config, pkgs, ... }:

{
  imports = [
  ];


  home = {
    username = "arthur19q3";
    homeDirectory = "/home/arthur19q3";
    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
  };
}