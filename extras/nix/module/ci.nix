# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT
# Minimal configuration that is accepted by "nixos-rebuild" + import of 
# modules to test.
{ lib, ... }:
{
  services.dash = {
    enable = true;
    secretsFile = ../../example.env;
  };

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}
