{
  description = "Tired of I.T! Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        arthur19q3 = lib.nixosSystem { 
          inherit system;
          modules = [ 
            ./configuration.nix
            ./hardware-configuration.nix
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true; 
              home-manager.useUserPackages = true;
              home-manager.users.arthur19q3 = {
                imports = [ ./home.nix ];

              };
            }
          ];
        };
      };  
      };

    }