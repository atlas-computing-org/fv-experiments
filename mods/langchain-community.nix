{ buildPythonPackage
, fetchPypi
, poetry-core
}:
buildPythonPackage rec {
  pname = "langchain_community";
  version = "0.2.12";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1nHPxqTztl9JouWatCDQFk8QnQpW/EtJllGCBcY7jH4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];
}
