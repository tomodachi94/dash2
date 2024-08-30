# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{
  description = "Application packaged using poetry2nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, pre-commit-hooks, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
          pkgs = nixpkgs.legacyPackages.${system};
          inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication defaultPoetryOverrides;
          # See https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
          dashOverrides = defaultPoetryOverrides.extend (self: super: {
            types-networkx = super.types-networkx.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.setuptools ];
            });
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

          devShells = import ./extras/nix/devshells.nix { inherit pkgs system self; };

          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                just-ci = {
                  enable = true;
                  name = "just ci";
                  entry = "just ci";
                  pass_filenames = false;
                };
              };
            };
          };
        }) // {
      nixosModules.default = ./extras/nix/module.nix;
    };
}
