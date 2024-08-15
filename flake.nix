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
      nixosModules.default = { config, lib, pkgs, dash2, ... }:
        {
          options.services.dash = {
            enable = lib.mkEnableOption "Dash, a bot for the FTB Wiki Discord (github.com/tomodachi94/dash2)";
            package = lib.mkPackageOption dash2.packages.${pkgs.system} "dash" { };

            mediawiki-api-url = lib.mkOption {
              type = lib.types.str;
              default = "https://ftb.fandom.com/api.php";
            };

            mediawiki-base-url = lib.mkOption {
              type = lib.types.str;
              default = "https://ftb.fandom.com/wiki/";
            };

            secretsFile = lib.mkOption {
              type = lib.types.path;
              default = null;
              example = "/run/secrets/dash";
              description = ''
                Secrets to run Dash.
              '';
            };
          };

          config = lib.mkIf config.services.dash.enable {
            systemd.services.dash = {
              description = "Dash, a bot for the FTB Wiki Discord";
              documentation = [ "https://github.com/tomodachi94/dash2" ];
              wants = [ "network-online.target" ];
              after = [ "network-online.target" ];
              environment = {
                MEDIAWIKI_API = config.services.dash.mediawiki-api-url;
                MEDIAWIKI_BASE_URL = config.services.dash.mediawiki-base-url;
              };
              serviceConfig = {
                ExecStart = lib.getExe config.services.dash.package;
                EnvironmentFile = config.services.dash.secretsFile;
                DynamicUser = true;
                NoNewPrivileges = true;
                ProtectKernelLogs = true;
                ProtectKernelModules = true;
                ProtectKernelTunables = true;
                DevicePolicy = "closed";
                ProtectHome = true;
                ProtectControlGroups = true;
                RestrictNamespaces = true;
                RestrictRealtime = true;
                RestrictSUIDSGID = true;
                MemoryDenyWriteExecute = true;
                LockPersonality = true;
                ProtectHostname = true;
              };
            };
          };
        };
    };
}
