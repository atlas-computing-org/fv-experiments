{
  description = "Agentic Workflows";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { self, nixpkgs }: 
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      my-anthropic = ps: ps.callPackage ../mods/anthropic.nix {};
      my-langsmith = ps: ps.callPackage ../mods/langsmith.nix {};
      my-langchain = ps: ps.callPackage ../mods/langchain.nix {};
      my-langchain-anthropic = ps: ps.callPackage ../mods/langchain-anthropic.nix {};
      my-langchain-core = ps: ps.callPackage ../mods/langchain-core.nix {};

      py = ps: with ps; [
        python-dotenv
        (my-anthropic ps)
        (my-langsmith ps)
        (my-langchain ps)
        (my-langchain-anthropic ps)
        (my-langchain-core ps)
      ];

    in 
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = [ 
          (pkgs.python3.withPackages py)
        ];
      };
    };
}
