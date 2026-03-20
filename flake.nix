{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yeghia = import ./home/default.nix;
          }
        ];
      };
    };

    devShells.x86_64-linux.default = pkgs.mkShell {
      name = "stoat-flutter";

      buildInputs = with pkgs; [
        # Flutter + Dart
        flutter
        dart

        # Linux desktop target dependencies
        cmake
        ninja
        pkg-config
        gtk3
        glib
        pcre2
        libsecret    # flutter_secure_storage on Linux
        xz

        # Build tools
        clang
        lld

        sysprof
      ];

      shellHook = ''
        echo "🦫 Stoat Flutter dev shell"
        echo "Flutter: $(flutter --version 2>/dev/null | head -1)"
        echo "Dart:    $(dart --version 2>/dev/null)"
      '';
    };
  };
}
