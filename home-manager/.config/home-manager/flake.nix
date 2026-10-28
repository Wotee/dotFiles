{
  description = "Home Manager configuration of wote";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # Temporary pin for azure-cli until unstable's fabric/invoke mismatch is fixed.
    nixpkgs-azure-cli.url = "github:nixos/nixpkgs/f20cd90e28fe0403873f473b29e42662cd86e8c4";
    adoboards = {
      url = "github:Wotee/adoboards-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tree-sitter = {
      url = "github:tree-sitter/tree-sitter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    nixpkgs,
    nixpkgs-azure-cli,
    home-manager,
    adoboards,
    opencode,
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
    azureCli = nixpkgs-azure-cli.legacyPackages.${system}.azure-cli;
    opencodePkgBase = opencode.packages.${system}.default;
    opencodePkg = opencodePkgBase.override {
      # The upstream flake's dependency hash is stale at this revision.
      node_modules = opencodePkgBase.node_modules.overrideAttrs (_: {
        outputHash = "sha256-I3JJjXdMbFpG+6gmecbFpPA67b6pdGey0tTmV3ciE0c=";
      });
    };
  in {
    homeConfigurations = {
      "${username}@Olkkari" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit azureCli opencodePkg;
          treeSitter = inputs.tree-sitter;
        };
        modules = commonModules ++ [ ./home.nix ];
      };
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit adoboards azureCli opencodePkg;
          treeSitter = inputs.tree-sitter;
        };
        modules = commonModules ++ [ ./work.nix ];
      };
    };
  };
}
