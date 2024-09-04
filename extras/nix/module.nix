# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, dash2, ... }:
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
}

