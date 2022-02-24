{
  description = "A flake to install the Gill Sans font family.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        gillsans = pkgs.fetchzip { url = "https://cdn.freefontsvault.com/wp-content/uploads/2020/02/03141445/Gill-Sans-Font-Family.zip";
                                   sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
                                   stripRoot = false; };
        fonts = pkgs.stdenv.mkDerivation {
          pname = "myfonts";
          version = "0.1.0";
          passthru.tlType = "run";
          src = ./myfonts;
          dontConfigure = true;
          src2 = gillsans;
          installPhase = ''
                       runHook preinstall
                       cp -R $src2 share/fonts/opentype/
                       cp -R share $out/
                       runHook postInstall
                       '';
          meta = { description = "Gill Sans font"; };
        };
      in
        {
          packages.myfonts = fonts;
          defaultPackage = self.packages.${system}.myfonts;
        }
    );
}
