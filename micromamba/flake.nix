{
  # TODO: Add a description
  description = "Description of project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };
  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
    });

    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          {
            packages = with pkgs; [
              micromamba
              zlib
              ruff
              just
            ];

            env = {GREET = "󱄅 Nix";};

            scripts.hello.exec = "echo $GREET";

            pre-commit.hooks = {
              ruff.enable = false;
              shellcheck.enable = true;
              markdownlint.enable = true;
              alejandra.enable = true;
              editorconfig-checker.enable = true;
            };

            dotenv.enable = true;

            env.LD_LIBRARY_PATH = with pkgs;
              lib.makeLibraryPath [
                zlib
              ];

            enterShell = ''
              set -h
              eval "$(micromamba shell hook --shell=zsh)"
            '';
          }
        ];
      };
    });
  };
}
