{
  # TODO: Update the description
  description = "A project with a Micromamba FHS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    self,
    nixpkgs,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: {
      # example-package = pkgs.hello;
    });

    devShells = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # <<< The FHS shell is now the default shell >>>
      default = pkgs.buildFHSUserEnv {
        name = "mamba-fhs-environment";
        targetPkgs = _: [
          pkgs.micromamba
          pkgs.zlib
          pkgs.ruff
          pkgs.just
        ];
        profile = ''
          set -e
          eval "$(micromamba shell hook --shell=zsh)"

          micromamba activate my-mamba-environment

          echo "FHS Mamba environment is ready!"
          set +e
        '';
      };
    });
  };
}
