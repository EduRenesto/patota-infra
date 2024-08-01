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

  services.openssh.enable = true;

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

  services.loki = {
    enable = true;
    configuration = {
      server.http_listen_port = 3002;
      common = {
        ring = {
          instance_addr = "127.0.0.1";
          kvstore.store = "inmemory";
        };
        replication_factor = 1;
        path_prefix = "/tmp/loki";
      };

      schema_config.configs = [
        {
          from = "2020-05-15";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];

      storage_config.filesystem.directory = "/tmp/loki/chunks";
    };
  };

  services.grafana = {
    enable = true;
    settings.server.http_port = 3000;
    settings.server.http_addr = "127.0.0.1";
    settings.server.domain = "grafana.patota.online";
  };

  services.prometheus = {
    enable = true;
    port = 3001;
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.grafana.settings.server.domain} = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
      };
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 3001 3002 ];
  };

  services.rouxinold-bot.enable = true;

  system.stateVersion = "24.04";
}
