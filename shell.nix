with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "bicikelj-sh";
    buildInputs = with pkgs; [
      curl
      jq
      bash
    ];
}
