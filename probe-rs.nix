{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, libusb1
, openssl
, DarwinTools
, AppKit
}:

rustPlatform.buildRustPackage rec {
  pname = "probe-rs";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "cf6ae5e5761731c228a2753617b46dd03869e8ac";
    sha256 = "sha256-aLe8ERHgWSOILXfhbABpxLAEucJx8Bv0ZYrOLdqzmoU=";
  };

  cargoSha256 = "sha256-QYYEkHEomsWvD00o5k36R3fAa5cgJ8PdQiFEpPqiVbE=";

  cargoBuildFlags = [ ];

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.isDarwin [ DarwinTools ];

  buildInputs = [ libusb1 openssl ] ++ lib.optionals stdenv.isDarwin [ AppKit ];

  meta = with lib; {
    description = "CLI tool for on-chip debugging and flashing of ARM chips";
    homepage = "https://probe.rs/";
    changelog = "https://github.com/probe-rs/probe-rs/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ xgroleau newam ];
  };
}
