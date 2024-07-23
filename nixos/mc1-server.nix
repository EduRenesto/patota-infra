{ config, lib, pkgs, ... }: {
  networking.useDHCP = true;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.grub.enable = true;

  networking.hostname = "mc1.patota.cloud";

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "24.02";

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      openFirewall = true;
    };
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINoMBnGCHBcsy+gagZOKhDSVRGS8gDCsYJLbKa2P8FH7 edu@Edus-MacBook-Pro.local"
  ];
}
