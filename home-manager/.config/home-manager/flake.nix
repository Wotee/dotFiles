{
  description = "Home Manager configuration of wote";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    adoboards = {
      url = "github:Wotee/adoboards-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:sst/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    adoboards,
    opencode,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations = {
      "wote@Olkkari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit opencode; };
        modules = [
          ./home.nix
          ./tmux.nix
          ./zsh.nix
        ];
      };
      "wote" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit adoboards; inherit opencode; };
        modules = [
          ./work.nix
          ./zsh.nix
        ];
      };
    };
  };
}
