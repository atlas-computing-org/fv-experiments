{
  description = "Autoformalization Demo";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { self, nixpkgs }: 
    let

      system = "x86_64-linux";

      # enable "allowUnfree" to install CUDA
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      
      ollama_cuda = pkgs.ollama.override { acceleration = "cuda"; };

      pypi-anthropic = pkgs.python3Packages.buildPythonPackage rec {
        pname = "anthropic";
        version = "0.34.1";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-aegivXox7BHC7bhfIUfo8O4M/TKI/qcLDKiAiy+b+R0=";
        };
        buildInputs = with pkgs.python3Packages; [ hatch-fancy-pypi-readme ];
      };

      pypi-langchain = pkgs.python3Packages.buildPythonPackage rec {
        pname = "langchain";
        version = "0.2.14";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-3CqlpYiCBU+10EPDmrgzLr0FX4jxeDnaaOHH/QpP7+I=";
        };
        buildInputs = with pkgs.python3Packages; [ poetry-core ];
      };

      pypi-langchain-core = pkgs.python3Packages.buildPythonPackage rec {
        pname = "langchain_core";
        version = "0.2.34";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-UASNkLF1wNWn4oFkYos8f4yCsNws12amY9NGoY1cnrI=";
        };
        buildInputs = with pkgs.python3Packages; [ poetry-core ];
      };

      pypi-langchain-community = pkgs.python3Packages.buildPythonPackage rec {
        pname = "langchain_community";
        version = "0.2.12";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-1nHPxqTztl9JouWatCDQFk8QnQpW/EtJllGCBcY7jH4=";
        };
        buildInputs = with pkgs.python3Packages; [ poetry-core ];
      };

      pypi-langsmith = pkgs.python3Packages.buildPythonPackage rec {
        pname = "langsmith";
        version = "0.1.104";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-eJLf5FLRQ/ulc9frKNv/MgLS8tqsq4xydv/kqFAXnU0=";
        };
        buildInputs = with pkgs.python3Packages; [ poetry-core ];
      };

      pypi-langchain-anthropic = pkgs.python3Packages.buildPythonPackage rec {
        pname = "langchain_anthropic";
        version = "0.1.23";
        format = "pyproject";
        doCheck = false;
        src = pkgs.python3Packages.fetchPypi {
          inherit pname version;
          hash = "sha256-8s4EW9CuCdXxH+1LhKOM4waCK3vKx3IyNF9AEV32bVE=";
        };
        buildInputs = with pkgs.python3Packages; [ poetry-core ];
      };

      pyPkgs = pythonPackages: with pythonPackages; [
        python-dotenv
        pydantic
        httpx
        distro
        orjson
        jsonpatch
        pyyaml
        pypi-anthropic
        pypi-langsmith
        pypi-langchain
        pypi-langchain-core
        pypi-langchain-community
        pypi-langchain-anthropic
      ];
    in 
    {
      devShells."${system}" = {
        default = pkgs.mkShell {
          buildInputs = [
            (pkgs.python3.withPackages pyPkgs)
            pkgs.streamlit 
            ollama_cuda
          ];
          shellHook = ''
            ollama serve &
            sleep 10
            ollama pull llama3
          '';
        };
      };
    };
}
