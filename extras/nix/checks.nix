# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{ self, system, pre-commit-hooks }:
{
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
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

