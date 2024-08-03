{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    rouxinold-bot.url = "github:EduRenesto/rouxinold-bot";
    rouxinold-bot.inputs.nixpkgs.follows = "nixpkgs";

    rouxinold-autohalt.url = "github:EduRenesto/rouxinold-autohalt/v0.1.0";
    rouxinold-autohalt.inputs.nixpkgs.follows = "nixpkgs";

    rouxinold-mc-exporter.url = "github:EduRenesto/rouxinold-mc-exporter/v0.1.0";
    rouxinold-mc-exporter.inputs.nixpkgs.follows = "nixpkgs";

    mc-forge-nix.url = "github:EduRenesto/minecraft-forge-nix";
    mc-forge-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    rouxinold-bot,
    rouxinold-autohalt,
    rouxinold-mc-exporter,
    mc-forge-nix,
    ...
  }: {
    devShells.aarch64-darwin.default = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in pkgs.mkShell {
      buildInputs = with pkgs; [
        opentofu
        nodejs
        yarn

        deploy-rs.packages.aarch64-darwin.default
      ];
    };

    nixosConfigurations.rxnl-wdog = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ rouxinold-bot.overlays.rouxinold ]; })
        rouxinold-bot.nixosModules.rouxinold
        ./nixos/configuration-rxnl-wdog.nix
      ];
    };

    nixosConfigurations.rxnl-mc1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ config, pkgs, ... }: {
          nixpkgs.overlays = [
            rouxinold-autohalt.overlays.rouxinold-autohalt
            rouxinold-mc-exporter.overlays.rouxinold-mc-exporter
            mc-forge-nix.overlays.x86_64-linux.default
          ];
        })
        rouxinold-autohalt.nixosModules.rouxinold-autohalt
        rouxinold-mc-exporter.nixosModules.rouxinold-mc-exporter
        ./nixos/configuration-rxnl-mc1.nix
      ];
    };

    deploy.nodes.rxnl-wdog = {
      hostname = "grafana.patota.online";
      sshOpts = [ "-p 2212" ];
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rxnl-wdog;
      };
    };

    deploy.nodes.rxnl-mc1 = {
      hostname = "mc.patota.online";
      sshOpts = [ "-p 2212" ];
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rxnl-mc1;
      };
    };
  };
}
