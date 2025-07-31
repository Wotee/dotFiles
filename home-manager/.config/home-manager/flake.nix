{
  description = "Home Manager configuration of wote";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      "wote@Olkkari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ./tmux.nix
          ./zsh.nix
        ];
      };
      "wote" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./work.nix
          ./zsh.nix
        ];
      };
    };
  };
}
