# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{ self, system, pkgs }:
{
  default = pkgs.mkShellNoCC {
    packages = with pkgs; [
      just
      poetry
      reuse
      ruff
      treefmt
      nixpkgs-fmt
      taplo
      yamlfmt
      statix
    ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
    inherit (self.checks.${system}.pre-commit-check) shellHook;
  };
  ci = pkgs.mkShellNoCC {
    packages = with pkgs; [
      just
      poetry
      reuse
      ruff
      mypy
      nixpkgs-fmt
      taplo
      yamlfmt
      treefmt
    ];
  };
}
