# home.nix

{ config, pkgs, ... }:

{
  # init info
  home.username = "arthur19q3";
  home.homeDirectory = "/home/arthur19q3";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  # empty

  # Programme settings
  programs.git = {
      enable = true;
      userName  = "arthur19q3";
      userEmail = "theartoforz@gmail.com";
    };
   home.file.".cargo/config.toml".text = ''
       [source.crates-io]
       replace-with = 'sjtu'

       [source.sjtu]
       registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"
     '';
}

