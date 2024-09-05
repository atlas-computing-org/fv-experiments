{ buildPythonPackage
, fetchPypi
, poetry-core
}:
buildPythonPackage rec {
  pname = "langchain_anthropic";
  version = "0.1.23";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8s4EW9CuCdXxH+1LhKOM4waCK3vKx3IyNF9AEV32bVE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
}
