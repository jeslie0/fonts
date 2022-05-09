{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts";
          version = "0.1.3";
          paths = with self.packages.${system}; [ gillsans ]; # Add font derivation names here
        };

        packages.gillsans = pkgs.stdenvNoCC.mkDerivation {
          name = "gillsans-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://cdn.freefontsvault.com/wp-content/uploads/2020/02/03141445/Gill-Sans-Font-Family.zip";
            sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/opentype/
          '';
          meta = { description = "A Gill Sans Font Family derivation."; };

        };
      });
}
