{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };

          rustToolchain = pkgs.pkgsBuildHost.rust-bin.fromRustupToolchainFile ./rust-toolchain-nightly.toml;
          rustPlatform = rustToolchain.rustPlatform;
          # new! 👇
          nativeBuildInputs = with pkgs; [ rustToolchain pkg-config ];
          # also new! 👇
          # buildInputs = [sha256-QYYEkHEomsWvD00o5k36R3fAa5cgJ8PdQiFEpPqiVbEo (pkgs.callPackage ./probe-rs.nix { }) ];
        in
        with pkgs;
        {
          packages.probe-rs = pkgs.callPackage ./probe-rs.nix { };
          devShells.default = mkShell {
            # 👇 and now we can just inherit them
            inherit buildInputs nativeBuildInputs;
          };
        }
      );
}
