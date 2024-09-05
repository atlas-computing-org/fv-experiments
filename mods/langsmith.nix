{ buildPythonPackage
, fetchPypi
, poetry-core
}:
buildPythonPackage rec {
  pname = "langsmith";
  version = "0.1.104";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eJLf5FLRQ/ulc9frKNv/MgLS8tqsq4xydv/kqFAXnU0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
}
