{
  description = "Autoformalization Demo";

  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

  outputs = { self, nixpkgs }: 
    let

      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      py3Pkgs = pkgs.python3Packages;
      
      pypi-anthropic = py3Pkgs.buildPythonPackage rec {
        pname = "anthropic";
        version = "0.34.1";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-aegivXox7BHC7bhfIUfo8O4M/TKI/qcLDKiAiy+b+R0=";
        };
        buildInputs = with py3Pkgs; [ hatch-fancy-pypi-readme ];
      };

      pypi-langchain = py3Pkgs.buildPythonPackage rec {
        pname = "langchain";
        version = "0.2.14";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-3CqlpYiCBU+10EPDmrgzLr0FX4jxeDnaaOHH/QpP7+I=";
        };
        buildInputs = with py3Pkgs; [ poetry-core ];
      };

      pypi-langchain-core = py3Pkgs.buildPythonPackage rec {
        pname = "langchain_core";
        version = "0.2.34";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-UASNkLF1wNWn4oFkYos8f4yCsNws12amY9NGoY1cnrI=";
        };
        buildInputs = with py3Pkgs; [ poetry-core ];
      };

      pypi-langchain-community = py3Pkgs.buildPythonPackage rec {
        pname = "langchain_community";
        version = "0.2.12";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-1nHPxqTztl9JouWatCDQFk8QnQpW/EtJllGCBcY7jH4=";
        };
        buildInputs = with py3Pkgs; [ poetry-core ];
      };

      pypi-langsmith = py3Pkgs.buildPythonPackage rec {
        pname = "langsmith";
        version = "0.1.104";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-eJLf5FLRQ/ulc9frKNv/MgLS8tqsq4xydv/kqFAXnU0=";
        };
        buildInputs = with py3Pkgs; [ poetry-core ];
      };

      pypi-langchain-anthropic = py3Pkgs.buildPythonPackage rec {
        pname = "langchain_anthropic";
        version = "0.1.23";
        format = "pyproject";
        doCheck = false;
        src = py3Pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-8s4EW9CuCdXxH+1LhKOM4waCK3vKx3IyNF9AEV32bVE=";
        };
        buildInputs = with py3Pkgs; [ poetry-core ];
      };

    in 
    {
      devShells."${system}".default = pkgs.mkShell {
        buildInputs = with py3Pkgs; [
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
        ] ++ [ pkgs.streamlit ];
      };
    };
}
