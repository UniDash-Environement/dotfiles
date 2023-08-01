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
    username = {
      user1 = "gabriel";
      user2 = "evnoxay";
    };
    system = "x86_64-linux";

    default_modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users = {
          ${username.user1} = import ./home/users/user1.nix;
          ${username.user2} = import ./home/users/user2.nix;
        };
        home-manager.extraSpecialArgs = {
          inherit username;
        };
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
          ./config/SRV/A

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/SRV/A;
            home-manager.users.${username.user2} = import ./home/SRV/A;
          }
        ];
      };
      UniDash-NAS-A = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-A"; })
          ./hardware/NAS/A.nix
          ./config/NAS/A

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/NAS/A;
            home-manager.users.${username.user2} = import ./home/NAS/A;
          }
        ];
      };
      UniDash-SRV-B = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-SRV-B"; })
          ./hardware/SRV/B.nix
          ./config/SRV/B

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/SRV/B;
            home-manager.users.${username.user2} = import ./home/SRV/B;
          }
        ];
      };
      UniDash-NAS-B = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-B"; })
          ./hardware/NAS/B.nix
          ./config/NAS/B

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/NAS/B;
            home-manager.users.${username.user2} = import ./home/NAS/B;
          }
        ];
      };
      UniDash-SRV-C = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-SRV-C"; })
          ./hardware/SRV/C.nix
          ./config/SRV/C

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/SRV/C;
            home-manager.users.${username.user2} = import ./home/SRV/C;
          }
        ];
      };
      UniDash-NAS-C = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = default_modules ++ [
          (import ./config { hostname = "UniDash-NAS-C"; })
          ./hardware/NAS/C.nix
          ./config/NAS/C

          home-manager.nixosModules.home-manager {
            home-manager.users.${username.user1} = import ./home/NAS/C;
            home-manager.users.${username.user2} = import ./home/NAS/C;
          }
        ];
      };
    };
  };
}
