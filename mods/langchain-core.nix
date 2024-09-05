{ buildPythonPackage
, fetchPypi
, poetry-core
}:
buildPythonPackage rec {
  pname = "langchain_core";
  version = "0.2.34";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UASNkLF1wNWn4oFkYos8f4yCsNws12amY9NGoY1cnrI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
}
