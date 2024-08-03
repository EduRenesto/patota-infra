{ modulesPath, config, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.efi = {
    canTouchEfiVariables = false;
    efiSysMountPoint = "/boot/efi";
  };
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/62004765-ab75-4606-9b7d-85d551ad254c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0D60-CDE2";
    fsType = "vfat";
  };

  fileSystems."/srv" = {
    device = "/dev/disk/by-uuid/e5839a38-cca7-4015-9fd3-34c393b12e14";
    fsType = "ext4";
  };

  networking.hostName = "rxnl-mc1";

  services.openssh = {
    enable = true;
    ports = [ 2212 ];
    openFirewall = true;
    settings = {
      AllowUsers = [ "root" "rhaenys" ];
      PasswordAuthentication = false;
    };
  };

  services.endlessh-go = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    neovim
    python3
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINoMBnGCHBcsy+gagZOKhDSVRGS8gDCsYJLbKa2P8FH7 edu@Edus-MacBook-Pro.local"
  ];

  users.users.rhaenys = {
    name = "rhaenys";
    group = "rhaenys";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINoMBnGCHBcsy+gagZOKhDSVRGS8gDCsYJLbKa2P8FH7 edu@Edus-MacBook-Pro.local"
    ];
    isNormalUser = true;
  };

  users.groups.rhaenys = {};

  services.prometheus.exporters = {
    node = {
      enable = true;
      enabledCollectors = [ "systemd" "cpu" "meminfo" ];
      port = 9000;
      openFirewall = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 3001 3002 9001 25565 ];
  };

  services.rouxinold-autohalt.enable = true;
  services.rouxinold-mc-exporter.enable = true;

  services.minecraft-server = {
    enable = false;
    package = pkgs.minecraftServers.forge-1-20;
    openFirewall = true;
    eula = true;
    declarative = false;
    dataDir = "/srv/minecraft";

    jvmOpts = "-Xms15G -Xmx15G";
  };

  services.fail2ban.enable = true;

  systemd.services.minecraft-server = {
    description = "Minecraft Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash ${pkgs.minecraftServers.forge-1-20}/bin/minecraft-server -Xms14G -Xmx14G";
      Restart = "always";
      User = "minecraft";
      WorkingDirectory = "/srv/minecraft";
    };
  };

  users.users.minecraft = {
    name = "minecraft";
    group = "minecraft";
    isSystemUser = true;
  };

  users.groups.minecraft = {};
}
