{ buildPythonPackage
, fetchPypi
, poetry-core
}:
buildPythonPackage rec {
  pname = "langchain";
  version = "0.2.14";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3CqlpYiCBU+10EPDmrgzLr0FX4jxeDnaaOHH/QpP7+I=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
}
