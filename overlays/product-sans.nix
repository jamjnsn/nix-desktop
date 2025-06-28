self: super: {
  product-sans = super.stdenv.mkDerivation {
    name = "product-sans";
    src = ../resources/fonts/product-sans;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp *.ttf $out/share/fonts/truetype/
    '';

    meta = {
      description = "Google Product Sans font family";
    };
  };
}
