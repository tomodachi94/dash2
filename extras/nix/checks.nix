# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{ self, pkgs, pre-commit-hooks }:
{
  pre-commit-check = pre-commit-hooks.lib.${pkgs.system}.run {
    src = self;
    hooks = {
      just-ci = {
        enable = true;
        name = "just ci";
        entry = "just ci";
        pass_filenames = false;
      };
    };
  };
  nixos-module-test-check = (pkgs.nixos [
    self.nixosModules.default
    ({ ... }: {
      # Workaround: We are unable to pass dash2 as an input without more boilerplate
      services.dash.package = self.packages.${pkgs.system}.dash;
    })
  ]
  ).config.system.build.toplevel;
}
