self: super: {
  sheldon = super.sheldon.overrideAttrs (oldAttrs: rec {
    pname = "sheldon";
    version = "0.7.4";
    src = super.fetchFromGitHub {
      owner = "rossmacarthur";
      repo = pname;
      rev = version;
      hash = "sha256-foIC60cD2U8/w40CVEgloa6lPKq/+dml70rBroY5p7Q=";
    };
    cargoDeps = oldAttrs.cargoDeps.overrideAttrs (super.lib.const {
        inherit src;
        name = "${pname}-${version}-vendor.tar.gz";
        outputHash = "sha256-XY8FtZcTKoWB9GpooJv16OrqqRDKK86lor2TsyRxLtw=";
    });
    cargoSha256 = "";
    meta = oldAttrs.meta // {
      platforms = super.lib.platforms.unix;
    };
  });
}
