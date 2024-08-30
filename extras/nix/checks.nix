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
}

