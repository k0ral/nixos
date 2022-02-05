{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ./programs.nix ./services.nix ];

  boot = {
    cleanTmpDir = true;
    kernelModules = [ "coretemp" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    supportedFilesystems = [ "zfs" ];
  };

  console.keyMap = "us";

  environment.variables = {
    BEMENU_BACKEND = "wayland";
    BROWSER = "brave";
    EDITOR = "nvim";
    FZF_DEFAULT_COMMAND = "fd --type f";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  fonts = {
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      # encode-sans
      font-awesome
      nerdfonts
      # noto-fonts
      # google-fonts
      # source-han-sans
      # source-han-mono
      # source-han-serif
      ubuntu_font_family
      unifont # some international languages
    ];
    fontconfig.defaultFonts.monospace = [ "Hack" ];
  };

  hardware = {
    bluetooth.enable = true;

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };

    pulseaudio = {
      enable = true;
      support32Bit = true;
      tcp.enable = true;
      tcp.anonymousClients.allowAll = true;
      zeroconf.discovery.enable = true;
      zeroconf.publish.enable = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    firewall.allowedTCPPorts = [ 873 6600 ];
    enableIPv6 = true;
    hostId = "01ed4135";
    hostName = "mystix";
    networkmanager.enable = true;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
    nixPath = [ "nixpkgs=/home/nixpkgs" "nixos-config=/etc/nixos/configuration.nix" "home-manager=/home/home-manager" ];
    package = pkgs.nixFlakes;
    settings = {
      auto-optimise-store = true;
      sandbox = true;
      substituters = [ "https://cache.nixos.org/" ];
      trusted-users = [ "@wheel" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  nixpkgs.overlays = [ (import ./overlays.nix) ];

  powerManagement = {
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  security.pam.services.sddm.enableGnomeKeyring = true;
  security.polkit.extraConfig = ''
    // Allow udisks2 to mount devices without authentication
    // for users in the "wheel" group.
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
             action.id == "org.freedesktop.udisks2.filesystem-mount") &&
            subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
    });
  '';

  system.autoUpgrade.enable = false;

  time.timeZone = "Europe/Paris";

  users.extraUsers.koral = {
    createHome = true;
    extraGroups = [ "adbusers" "aria2" "audio" "docker" "wheel" "sway" ];
    isNormalUser = true;
    shell = pkgs.fish;
    uid = 1000;
  };

  virtualisation.docker.enable = true;

  xdg = {
    icons.enable = true;
    # portal.enable = true;
    # portal.gtkUsePortal = true;
    # portal.extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    # portal.wlr.enable = true;
  };
}
