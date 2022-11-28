{
  description = "nix-closure-gexf flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/22.05";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      { packages.default = pkgs.callPackage ./. { }; }
    );
}
