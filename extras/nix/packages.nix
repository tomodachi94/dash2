# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

{ self, system, pkgs, poetry2nix }:
let
  # see https://github.com/nix-community/poetry2nix/tree/master#api for more functions and examples.
  inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication defaultPoetryOverrides;
  inherit (pkgs.dockerTools) streamLayeredImage;
  # See https://github.com/nix-community/poetry2nix/blob/master/docs/edgecases.md#modulenotfounderror-no-module-named-packagename
  dashOverrides = defaultPoetryOverrides.extend (self: super: {
    types-networkx = super.types-networkx.overridePythonAttrs (oldAttrs: {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [ ] ++ [ self.pythonPackages.setuptools ];
    });
  });
in
rec {
  dash = mkPoetryApplication {
    projectDir = self;
    overrides = dashOverrides;
    meta.mainProgram = "dash";
  };
  default = dash;
  dash-container = streamLayeredImage {
    name = "io.github.tomodachi94.dash2";
    config.Cmd = [ "${dash}/bin/dash" ];
  };
}
