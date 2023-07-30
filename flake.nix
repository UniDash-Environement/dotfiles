{
  description = "UniDash dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    hosts.url = github:StevenBlack/hosts;

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, home-manager, hosts, ... } @inputs:
  let
    username = "gabriel";
    system = "x86_64-linux";

    default_modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = import ./home;
        home-manager.extraSpecialArgs = { inherit username; };
      }
    ];

  in
  {
    nixosConfigurations = {
      UniDash-SRV-A = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-SRV-A"; })
          ./hardware/SRV/A.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/SRV/A;
          }
        ];
      };
      UniDash-NAS-A = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-A"; })
          ./hardware/NAS/A.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/NAS/A;
          }
        ];
      };
      UniDash-SRV-B = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-SRV-B"; })
          ./hardware/SRV/B.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/SRV/B;
          }
        ];
      };
      UniDash-NAS-B = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-B"; })
          ./hardware/NAS/B.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/NAS/B;
          }
        ];
      };
      UniDash-SRV-C = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-SRV-C"; })
          ./hardware/SRV/C.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/SRV/C;
          }
        ];
      };
      UniDash-NAS-C = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-C"; })
          ./hardware/NAS/C.nix

          home-manager.nixosModules.home-manager {
            home-manager.users.${username} = import ./home/NAS/C;
          }
        ];
      };
    };
  };
}
