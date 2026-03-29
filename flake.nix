{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:mic92/sops-nix";
  };
  outputs = { self, nixpkgs, home-manager, flake-utils, sops-nix, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules = [
                sops-nix.homeManagerModules.sops
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yeghia = import ./home/default.nix;
          }
        ];
      };
    };

    devShells.x86_64-linux = {
      default = pkgs.mkShell {
        name = "stoat-flutter";

        buildInputs = with pkgs; [
          flutter
          dart
          cmake
          ninja
          pkg-config
          gtk3
          glib
          pcre2
          libsecret
          xz
          clang
          lld
          sysprof
        ];

        shellHook = ''
          echo "Stoat Flutter dev shell"
          echo "Flutter: $(flutter --version 2>/dev/null | head -1)"
          echo "Dart:    $(dart --version 2>/dev/null)"
        '';
      };

      opengl = pkgs.mkShell {
        name = "opengl-engine";

        buildInputs = with pkgs; [
          gcc
          cmake
          pkg-config
          libGL
          libGLU
          glfw
          glm
        ];

        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (with pkgs; [
            libGL
            libGLU
          ])}:$LD_LIBRARY_PATH
          echo "OpenGL dev shell ready"
        '';
      };
    };
  };
}
