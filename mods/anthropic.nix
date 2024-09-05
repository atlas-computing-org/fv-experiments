{ buildPythonPackage
, fetchPypi
, hatch-fancy-pypi-readme
, pydantic
, httpx
, distro
, orjson
, jsonpatch
, pyyaml
, tenacity
, requests
}:
buildPythonPackage rec {
  pname = "anthropic";
  version = "0.34.1";
  pyproject = true;
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aegivXox7BHC7bhfIUfo8O4M/TKI/qcLDKiAiy+b+R0=";
  };

  propagatedBuildInputs = [
    hatch-fancy-pypi-readme
    pydantic
    httpx
    distro
    orjson
    jsonpatch
    pyyaml
    tenacity
    requests
  ];
}
