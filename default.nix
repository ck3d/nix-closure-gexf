{ runCommand
, lib
, makeWrapper
, jq
}:
let
  name = "nix-closure-gexf";
  buildInputs = [ jq ];
in
runCommand name
{
  inherit buildInputs;
  nativeBuildInputs = [ makeWrapper ];
} ''
  mkdir -p $out/bin
  makeWrapper ${./nix-closure-gexf} $out/bin/${name} \
    --prefix PATH : ${lib.makeBinPath buildInputs} \
    --set NIX_CLOSURE_GEXF_LIB ${./lib.jq}
''
