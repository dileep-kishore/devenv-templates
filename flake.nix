{
  description = "A collection of development environment configurations based on Nix flakes";

  outputs = {
    self,
    nixpkgs,
  }: {
    templates = {
      python = {
        path = ./python;
        description = "Python development environment";
      };
      quarto = {
        path = ./quarto;
        description = "Quarto notes environment";
      };
      julia = {
        path = ./julia;
        description = "Julia development environment";
      };
      micromamba = {
        path = ./micromamba;
        description = "Micromamba environment for Python";
      };
    };
  };
}
