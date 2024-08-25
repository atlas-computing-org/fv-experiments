{
  description = "Agentic";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-24.05;

  outputs = { self, nixpkgs }: 
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      
      # Grab the latest version of LangChain from PyPi
      format = "wheel";
      dist = "py3";
      python = "py3";
      anthropic0 = pkgs.python3Packages.buildPythonPackage rec {
        inherit format;
        pname = "anthropic";
        version = "0.34.1";
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version format dist python;
          hash = "sha256-L6JnEICdCWDZcPJs0L42hkNyUKSB7blcM9g3ql+iQVg=";
        };
      };
      langchain0 = pkgs.python3Packages.buildPythonPackage rec {
        inherit format;
        pname = "langchain";
        version = "0.2.14";
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version format dist python;
          hash = "sha256-7tdhlO59nAgQN6PfeGjU3pDgQQtR/BypM6g3nkZL9Aw=";
        };
      };
      langchain0-core = pkgs.python3Packages.buildPythonPackage rec {
        inherit format;
        pname = "langchain_core";
        version = "0.2.34";
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version format dist python;
          hash = "sha256-xP0VgnPijO91i07MyVa0JLdtS7kRfOYBSubrL7mFgB0=";
        };
      };
      langsmith0 = pkgs.python3Packages.buildPythonPackage rec {
        inherit format;
        pname = "langsmith";
        version = "0.1.104";
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version format dist python;
          hash = "sha256-BJzTEpUqDbn17e7TuahhbmbvhuVJDINci7BUVpIDsNA=";
        };
      };
      langchain0-anthropic = pkgs.python3Packages.buildPythonPackage rec {
        inherit format;
        pname = "langchain_anthropic";
        version = "0.1.23";
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version format dist python;
          hash = "sha256-icr9r0yeUiSEsMqLr8zrCl5P/KiffHyc7B4rpBEgggg=";
        };
      };

      # Add dependencies of LangChain
      pyPkgs = pythonPackages: with pythonPackages; [
        python-dotenv
        orjson
        jsonpatch
        pydantic
        httpx
        distro
        pyyaml
        anthropic0
        langsmith0
        langchain0
        langchain0-core
        langchain0-anthropic
      ];
    in 
    {
      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages pyPkgs)
            pkgs.streamlit 
          ];
        };
      };
    };
}
