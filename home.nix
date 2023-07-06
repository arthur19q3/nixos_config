# home.nix

{ config, pkgs, ... }:

{
#  imports = [
#    <home-manager/nixos>
#  ];

  home.username = "arthur19q3";
  home.homeDirectory = "/home/arthur19q3";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
  programs.git = {
      enable = true;
      userName  = "arthur19q3";
      userEmail = "theartoforz@gmail.com";
    };
}

