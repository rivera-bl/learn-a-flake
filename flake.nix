/* TODO: name the pkg and export explicitily as the default */
/* TODO: explicit the defaultapp */
/* this is a good example of the flake of an application using go, notheless it is more important to us, to apply a flake to a terminal tool and the nixos system*/
{
  description = "A simple Go package";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
        version = builtins.substring 0 8 lastModifiedDate;
        pkgs =  import nixpkgs { inherit system; };
      in
      {

        defaultPackage = pkgs.buildGoModule {
          pname = "go-hello";
          inherit version;
          src = ./.;

          vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
        };

        devShell = with pkgs; # avoid writing pkgs.mkShell, pkgs.go ..
          mkShell {
            buildInputs = [ go gopls gotools go-tools ];
         };
    });
}
