self: super: {
  gopls = super.gopls.overrideAttrs (oldAttrs: rec {
    pname = "gopls";
    version = "0.17.1";

    src = super.fetchFromGitHub {
      owner = "golang";
      repo = "tools";
      rev = "gopls/v${version}";
      hash = "sha256-NLUIFNooOOA4LEL5nZNdP9TvDkQUqLjKi44kZtOxeuI=";
    };

    vendorHash = "sha256-wH3YRiok3YWNzw9ejXMMitq58SxrNWXiKYKz2Hf0ZlM=";

    # https://github.com/golang/tools/blob/9ed98faa/gopls/main.go#L27-L30
    ldflags = [ "-X main.version=v${version}" ];
  });
}
