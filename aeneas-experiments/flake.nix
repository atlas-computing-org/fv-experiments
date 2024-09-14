{
  description = "Aeneas Experiments";

  inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/e31b9a627463cd653b9aa8f59679f3eb2ca8cffd;
  inputs.nixpkgs.follows = "aeneaspkgs/nixpkgs";

  outputs = { self, aeneaspkgs, nixpkgs }: 
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (aeneaspkgs.packages.${system}) aeneas charon;

    in 
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = [ 
          aeneas
          charon
        ];
      };
    };
}
