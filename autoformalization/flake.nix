{
  description = "Autoformalization Demo";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;

  outputs = { self, nixpkgs }: 
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

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
          pkgs.lean4
        ];
      };
    };
}
