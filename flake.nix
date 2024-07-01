{
  inputs = {
    nipkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { nixpkgs, ... }: {
    devShells.aarch64-darwin.default = let
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
    in pkgs.mkShell {
      buildInputs = with pkgs; [ opentofu ];
    };
  };
}
