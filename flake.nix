{
  inputs = {
    nixpkgs = {
      type = "github";
      owner = "nixos";
      repo = "nixpkgs";
      ref = "nixos-22.05";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-compat,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        inherit system;
        name = "siuta";
        src = ./.;
        builder = ./build.sh;
        buildInputs = [
          pkgs.bash
	  pkgs.openssl
          pkgs.quicklispPackages.alexandria
          pkgs.quicklispPackages.hunchentoot
          pkgs.quicklispPackages.serapeum
          pkgs.quicklispPackages.spinneret
          pkgs.quicklispPackages.uiop
          pkgs.sbcl
        ];
      };
    });
}
