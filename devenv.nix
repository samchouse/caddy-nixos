{ pkgs, lib, config, inputs, ... }:

{
  cachix.enable = false;
  packages = [ pkgs.git ];
  languages.go.enable = true;
}
