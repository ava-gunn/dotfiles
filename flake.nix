{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    defaultPackage.x86_64-darwin = home-manager.defaultPackage.x86_64-darwin;
 
    homeConfigurations = {
	    # TODO: Modify "your.username" below to match your username
      "clark" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-darwin"; # TODO: replace with x86_64-linux on Linux
        homeDirectory = "/Users/clark"; # TODO: make this match your home directory
        username = "clark"; # TODO: Change to your username
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}
