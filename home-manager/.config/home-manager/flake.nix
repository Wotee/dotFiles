{
  description = "Home Manager configuration of wote";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    adoboards = {
      url = "github:Wotee/adoboards-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # opencode = {
    #   url = "github:sst/opencode";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    adoboards,
    # opencode,
    ...
  }: let
    username = "wote";
    homeDirectory = "/home/${username}";
    commonModules = [
      {
        home.username = username;
        home.homeDirectory = homeDirectory;
      }
      ./zsh.nix
    ];
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations = {
      "${username}@Olkkari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # extraSpecialArgs = { inherit opencode; };
        modules = commonModules ++ [ ./home.nix ];
      };
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # extraSpecialArgs = { inherit adoboards; inherit opencode; };
        extraSpecialArgs = { inherit adoboards; };
        modules = commonModules ++ [ ./work.nix ];
      };
    };
  };
}
