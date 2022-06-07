{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ntfs3g
    gnome3.adwaita-icon-theme
  ];

  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;
    iftop.enable = true;
    light.enable = true;
    mosh.enable = true;
    mtr.enable = true;
    nano.nanorc = ''
      set nowrap
      set tabstospaces
      set tabsize 2
    '';
    seahorse.enable = true;
  };
}
