{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          authorizedKeys = pkgs.fetchurl {
            url = "https://meta.sr.ht/~ashymad.keys";

            downloadToTemp = true;
            postFetch = ''sort < "$downloadedFile" > "$out"'';

            hash = "sha256-quG35fiD5eWllp7O4Xzw9ZpfR0FGijYwIM2H1VRdyKc=";
          };
        in
        {
          keys = pkgs.lib.remove "" (pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys));
        }
      );
}
