{
  config,
  pkgs,
  ...
}: {
  home.username = "wote";
  home.homeDirectory = "/home/wote";

  home.stateVersion = "24.11";

  home.packages = [
    pkgs.stow
    pkgs.gh
  ];

  programs.home-manager.enable = true;
}
