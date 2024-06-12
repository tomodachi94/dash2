{ config, lib, pkgs, ... }:
{
  with lib;

  let
  cfg = config.services.dash;
  in
  {
  options.services.dash = {
    enable = mkEnableOption "Enable the Dash Discord bot";
    secretsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to a file containing environment variables (in .env format) to be passed to the bot. This file is intended for tokens; other configuration should go into other options.";
    };
    package = mkOption {
      type = types.package;
      default = self.packages.${pkgs.system}.default;
      defaultText = "dash2.packages.\${pkgs.system}.default";
      description = "Dash package to use";
    };
    mediawiki = mkOption {
      description = "options controlling the MediaWiki portions of the bot";
      type = with types; submodule {
        options = {
          base_url = mkOption {
            type = strMatching "https://.*";
            description = "The base URL of the MediaWiki instance.";
            default = "https://ftb.fandom.com/wiki/";
          };
          api = mkOption {
            type = strMatching "https://.*";
            description = "The full URL to the api.php on the MediaWiki instance.";
            default = "https://ftb.fandom.com/api.php";
          };
        };
      };
    };

    discord = mkOption {
      description = "options controlling the portions of the bot that interact with Discord";
      type = with types; submodule {
        options = {
          prefix = mkOption {
            type = str;
            description = "The text prefix for all non-slash commands for Dash.";
            default = "https://ftb.fandom.com/wiki/";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.dash = {
      description = "The Dash bot, a Discord bot for the FTB Wiki (github.com/tomodachi94/dash2)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.lib.getExe cfg.package}";
        EnvironmentFile = cfg.secretsFile;
        Environment = (mapAttrsToList (k: v: ''"${k}=%d/${k}"'') {
          DISCORD_PREFIX = cfg.discord.prefix;
          MEDIAWIKI_API = cfg.mediawiki.api;
          MEDIAWIKI_BASE_URL = cfg.mediawiki.base_url;
        });
      };
    };
  };
};
};
