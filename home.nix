# home.nix

{ config, pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home.username = "arthur19q3";
  home.homeDirectory = "/home/arthur19q3";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  # Declare Cargo package in home.packages
  home.packages = [
    pkgs.cargo
    # Add other packages if needed
  ];

  # Configure Cargo if necessary
  programs.cargo = {
    enable = true;
    # Add specific configuration options for Cargo here
  };

  # Other configurations...
  home-manager.users.arthur19q3.environment={
    #
  };
}

