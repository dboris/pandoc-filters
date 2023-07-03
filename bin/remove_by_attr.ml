module F = Pandoc_filters

let block f =
  let open Pandoc in function
  | CodeBlock (attr, _) when f attr -> Some []
  | Header (_, attr, _) when f attr -> Some []
  | Div (attr, _) when f attr -> Some []
  | Table (attr, _, _, _, _, _) when f attr -> Some []
  | Figure (attr, _, _) when f attr -> Some []
  | _ -> None

let inline f =
  let open Pandoc in function
  | Code (attr, _) when f attr -> Some []
  | Image (attr, _, _) when f attr -> Some []
  | Link (attr, _, _) when f attr -> Some []
  | Span (attr, _) when f attr -> Some []
  | _ -> None

let () =
  let json = Yojson.Basic.from_channel stdin in
  let p = Pandoc.of_json json in
  let attrs =
    try F.parse_params (List.assoc "remove-attr" (Pandoc.meta p))
    with _ ->
      failwith "Usage: pandoc -M remove-attr=k1:v1 remove-attr=k2:v2 ..."
  in
  let f = F.contains attrs in

  (* let s = Yojson.Basic.pretty_to_string json in
  prerr_endline s; *)

  p
  |> Pandoc.map
      ~block:(block f)
      ~inline:(inline f)
  |> Pandoc.to_json
  |> Yojson.Basic.pretty_to_string
  |> print_endline
