{
  description = "Caddy with Cloudflare plugin";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";
      version = builtins.substring 0 8 lastModifiedDate;

      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          caddy = pkgs.buildGo123Module {
            pname = "caddy";
            inherit version;
            src = ./caddy-src;
            runVend = true;
            vendorHash = "sha256-fgr64f1wOreFrMTAMnYTkaqAfrcG0tme4J3YVawoks0=";
            # vendorSha256 = pkgs.lib.fakeSha256;
          };
        }
      );

      defaultPackage = forAllSystems (system: self.packages.${system}.caddy);
    };
}
