# TODO: name the pkg and export explicitily as the default
# TODO: explicit the defaultapp
# TODO: don't override the result/ built with each package
{
  description = "A simple Go package";
  # can also be set system wide, see:
  # https://nixos.org/manual/nix/unstable/command-ref/conf-file.html#conf-bash-prompt
  nixConfig.bash-prompt = "\[nix-develop\]$ ";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages.default = pkgs.buildGoModule {
        pname = "go-hello";
        inherit version;
        src = ./.;

        vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
      };

      packages.docker = let
        hello = self.packages.${system}.default;
      in
        pkgs.dockerTools.buildLayeredImage {
          name = hello.pname;
          tag = hello.version;
          contents = [hello];

          config = {
            Cmd = ["/bin/go-hello"];
            WorkingDir = "/";
          };
        };

      devShells.default = with pkgs; # avoid writing pkgs.mkShell, pkgs.go ..
      
        mkShell {
          buildInputs = [go gopls gotools go-tools];
        };
    });
}
