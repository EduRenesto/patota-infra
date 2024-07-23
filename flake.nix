{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-generators, ... }: {
    devShells.aarch64-darwin.default = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in pkgs.mkShell {
      buildInputs = with pkgs; [ opentofu ];
    };

    packages.x86_64-linux.oci-image = nixos-generators.nixosGenerate {
      system = "x86_64-linux";
      modules = [
        ./nixos/mc1-server.nix
      ];
      format = "qcow";
    };
  };
}
