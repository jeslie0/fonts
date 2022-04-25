{
  description = "A flake to install the Gill Sans font family.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        # Fetches the Gill Sans font
        gillsans = pkgs.fetchzip { url = "https://cdn.freefontsvault.com/wp-content/uploads/2020/02/03141445/Gill-Sans-Font-Family.zip";
                                   sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
                                   stripRoot = false; };
      in
        {
          defaultPackage = pkgs.stdenv.mkDerivation {
            pname = "myfonts";
            version = "0.1.2";
            dontConfigure = true;
            src = ./.;
            src1 = gillsans;
            installPhase = ''
                       mkdir -p $out/share/fonts
                       cp -R $src1 $out/share/fonts/opentype/
                       '';
            meta = { description = "Gill Sans font"; };
          };
        }
    );
}
