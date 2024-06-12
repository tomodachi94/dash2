{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication defaultPoetryOverrides;
          # See https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
          dashOverrides = defaultPoetryOverrides.extend (self: super: {
            ezgiphy = super.ezgiphy.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ pkgs.python3Packages.setuptools ];
            });
            pymediawiki = super.pymediawiki.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ pkgs.python3Packages.setuptools ];
            });
            # Override some packages to take advantage of caching
            aiohttp = pkgs.python3Packages.aiohttp;
            hikari = pkgs.python3Packages.hikari;
          });
        in
        {
          packages = {
            dash = mkPoetryApplication {
              projectDir = self;
              overrides = dashOverrides;
              meta.mainProgram = "dash";
            };
            default = self.packages.${system}.dash;
            dash-container = pkgs.dockerTools.streamLayeredImage {
              name = "io.github.tomodachi94.dash2";
              config.Cmd = [ "${self.packages.${system}.dash}/bin/dash" ];
            };

          };

          devShells = {
            default = pkgs.mkShellNoCC {
              inputsFrom = [ self.packages.${system}.dash ];
              packages = with pkgs; [
                just
                poetry
                ruff
                treefmt
                nixpkgs-fmt
                statix
              ];
            };
            ci = pkgs.mkShellNoCC {
              packages = with pkgs; [
                just
                ruff
                nixpkgs-fmt
                treefmt
              ];
            };
          };
        });
}
