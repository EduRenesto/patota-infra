{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    rouxinold-bot.url = "github:EduRenesto/rouxinold-bot";
    rouxinold-bot.inputs.nixpkgs.follows = "nixpkgs";

    rouxinold-autohalt.url = "github:EduRenesto/rouxinold-autohalt";
    rouxinold-autohalt.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, deploy-rs, rouxinold-bot, rouxinold-autohalt, ... }: {
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

    deploy.nodes.rxnl-wdog = {
      hostname = "144.22.169.245";
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.rxnl-wdog;
      };
    };
  };
}
