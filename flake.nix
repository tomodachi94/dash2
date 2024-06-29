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
            ezgiphy = super.ezgiphy.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.setuptools ];
            });
            pymediawiki = super.pymediawiki.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.setuptools ];
            });
            svcs = super.svcs.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.hatchling self.pythonPackages.hatch-fancy-pypi-readme ];
            });
            hikari-lightbulb = super.hikari-lightbulb.overridePythonAttrs (oldAttrs: {
              propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.flit ];
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
              ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
              inherit (self.checks.${system}.pre-commit-check) shellHook;
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

          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                just-ci = {
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
              description = "Dash, a bot for the FTB Wiki Discord (github.com/tomodachi94/dash2)";
              after = [ "network.target" ];
              wantedBy = [ "multi-user.target" ];
              serviceConfig = {
                ExecStart = lib.getExe config.services.dash.package;
                Environment = ''
                  MEDIAWIKI_API=${config.services.dash.mediawiki-api-url}
                  MEDIAWIKI_BASE_URL=${config.services.dash.mediawiki-base-url}
                '';
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
