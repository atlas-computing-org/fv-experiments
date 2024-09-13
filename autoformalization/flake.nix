{
  description = "Autoformalization Demo";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;
  inputs.aeneaspkgs.url = github:AeneasVerif/aeneas/e31b9a627463cd653b9aa8f59679f3eb2ca8cffd;

  outputs = { self, nixpkgs, aeneaspkgs }: 
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      inherit (aeneaspkgs.packages.${system}) aeneas charon;

      my-streamlit = ps: ps.callPackage ../mods/streamlit.nix {};
      my-langchain-anthropic = ps: ps.callPackage ../mods/langchain-anthropic.nix {};

      py = ps: with ps; [
        python-dotenv
        anthropic
        langsmith
        langchain
        langchain-core
        langchain-community
        (my-streamlit ps)
        (my-langchain-anthropic ps)
      ];

    in 
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = [ 
          (pkgs.python3.withPackages py)
          pkgs.lean4    # for lean3, use pkgs.lean
          aeneas
          charon
        ];
      };
    };
}
