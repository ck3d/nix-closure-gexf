{
  description = "nix-closure-gexf flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-23.05";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    {
      packages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          default = pkgs.callPackage ./. { };
        });
    };
}
