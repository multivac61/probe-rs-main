{ probe-rs, fetchFromGitHub, lib }:
probe-rs.overrideAttrs (old: rec {
  src = fetchFromGitHub {
    owner = old.pname;
    repo = old.pname;
    rev = "master";
    hash = "sha256-aLe8ERHgWSOILXfhbABpxLAEucJx8Bv0ZYrOLdqzmoU=";
  };
  cargoBuildFlags = [ ];
  cargoDeps = old.cargoDeps.overrideAttrs (lib.const {
    inherit src;
    name = "${old.pname}-vendor.tar.gz";
    outputHash = "sha256-oz/MlqYlHoyT648qnTrLPJHBMaXW+wCsfneN2Jjuimk=";
  });
})
