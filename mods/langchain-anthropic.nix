{ buildPythonPackage
, fetchPypi
, anthropic
, defusedxml
, langchain-core
, poetry-core
}:
buildPythonPackage rec {
  pname = "langchain_anthropic";
  version = "0.1.13";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MuesUeGHTEfhogST519b/Iiw/+r18a7WCRVH4a5Eu4U=";
  };

  nativeBuildInputs = [
    anthropic
    defusedxml
    langchain-core
    poetry-core
  ];
}
