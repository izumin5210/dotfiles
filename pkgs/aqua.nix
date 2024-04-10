{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "aqua";
  src = pkgs.fetchurl {
    url = "https://github.com/aquaproj/aqua/releases/download/v2.27.0/aqua_darwin_arm64.tar.gz";
    sha256 = "sha256-z0UcCsSqi4Q7OhOyDENLLjD8dnfo4oKQcUx1Ny/q0qs=";
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp -r aqua $out/bin
  '';

  meta = {
    description = "Declarative CLI Version manager written in Go. Support Lazy Install, Registry, and continuous update with Renovate. CLI version is switched seamlessly";
    homepage = "https://github.com/aquaproj/aqua";
    license = pkgs.lib.licenses.mit;
  };
}
