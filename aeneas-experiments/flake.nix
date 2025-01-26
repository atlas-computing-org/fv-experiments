{
  description = "Aeneas Experiments";

  # inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/e31b9a627463cd653b9aa8f59679f3eb2ca8cffd;
  # inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/6c5bfa2c2b3b941a211cb702c31c281e0a8f6286;
  # inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/a5f5bf6dcfa62a4c1eefa339edd424cbfb433ec4;
  # inputs.aeneaspkgs.url = https://github.com/AeneasVerif/aeneas/archive/main.tar.gz;

  inputs.aeneaspkgs.url = github:AeneasVerif/aeneas;
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
