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
      packages = {
        default = pkgs.stdenv.mkDerivation {
          inherit system;
          name = "siuta";
          src = ./src;
          builder = ./build.sh;
          dontStrip = true;
          LD_LIBRARY_PATH = "${pkgs.openssl.out}/lib";
          buildInputs = [
            pkgs.bash
            pkgs.openssl.dev
            pkgs.which
            pkgs.makeWrapper
            pkgs.quicklispPackages.alexandria
            pkgs.quicklispPackages.hunchentoot
            pkgs.quicklispPackages.serapeum
            pkgs.quicklispPackages.spinneret
            pkgs.quicklispPackages.uiop
            pkgs.sbcl
          ];
        };
        docker = pkgs.dockerTools.buildImage {
          name = "siuta-docker";
          config = {
            Cmd = ["${self.packages.${system}.default}/bin/siuta"];
          };
        };
      };
    });
}
