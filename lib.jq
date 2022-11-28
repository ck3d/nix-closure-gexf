def name: capture("^/nix/store/[a-zA-Z0-9]{32}-(?<name>.*)$") | .name;

def optional(f; x): if f then x else . end;

def toXml:
  optional
  ( type == "array"
  ; .[] )
| if type == "object" then
    to_entries[]
  | .value |=
    ( . // []
    | optional
      ( type != "array"
      ; [ {}, . ] ))
  | { tag: .key
    , attr:
      ( .value[0] // {}
      | to_entries
      | map(" \(.key)=\"\(.value)\"")
      | add )
    , data:
      ( .value[1:]
      | map(toXml)
      | add )}
  | "<\(.tag)\(.attr // "")>\(.data // "")</\(.tag)>"
  else
    "\(. // "")"
  end
;

def nodes:
  reduce .[] as $in
  ( []
  ; .
  + [ { node:
        [ { id: $in.path
          , label: $in.path | name }
        , { attvalues:
            [ {}
            , { attvalue:
                [ { for: 0
                  , value: $in.narSize }]}
            , { attvalue:
                [ { for: 1
                  , value: $in.closureSize }]}]}]}])
;

def edges:
  reduce .[] as $in
  ( []
  ; .
  + [ ( $in.references[]
      | select(. != $in.path)
      | { edge:
          [ { source: $in.path
            , target: . }]})])
;

  { gexf:
    [ { xmlns: "http://gexf.net/1.3"
      , "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance"
      , "xsi:schemaLocation": "http://gexf.net/1.3 http://gexf.net/1.3/gexf.xsd"
      , version: "1.3" }
    , { meta:
        [ {}
        , { creator: "nix-closure-gexf"
          , keywords: "nix" }]}
    , { graph:
      [ { defaultedgetype: "directed" }
      , { attributes:
          [ { class: "node" }
          , { attribute:
              [ { id: 0
                , title: "narSize"
                , type: "biginteger" }]}
          , { attribute:
              [ { id: 1
                , title: "closureSize"
                , type: "biginteger" }]}]}
      , { nodes:
          [ {}
          , nodes ]}
      , { edges:
          [ {}
          , edges ]}]}]}
| toXml
