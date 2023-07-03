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

let contains_assoc xs k v =
  List.mem_assoc k xs && String.equal v (List.assoc k xs)

let contains filter_attrs (id, cls, kvs) =
  contains_assoc filter_attrs "id" id ||
  List.exists Fun.id (List.map (contains_assoc filter_attrs "class") cls) ||
  kvs
  |> List.map (fun (k, v) -> contains_assoc filter_attrs k v)
  |> List.exists Fun.id

let parse_param str =
  match String.split_on_char ':' str with
  | [k; v] -> k, v
  | _ -> assert false

let parse_params =
  let open Pandoc in function
  | MetaString s -> [parse_param s]
  | MetaList kvs ->
    kvs
    |> List.map begin function
        | MetaString s -> parse_param s
        | _ -> assert false
      end
  | _ -> assert false

let () =
  let json = Yojson.Basic.from_channel stdin in
  let p = Pandoc.of_json json in
  let attrs =
    try parse_params (List.assoc "remove-attr" (Pandoc.meta p))
    with _ ->
      failwith "Usage: pandoc -M remove-attr=k1:v1 remove-attr=k2:v2 ..."
  in
  let f = contains attrs in

  (* let s = Yojson.Basic.pretty_to_string json in
  prerr_endline s; *)

  p
  |> Pandoc.map
      ~block:(block f)
      ~inline:(inline f)
  |> Pandoc.to_json
  |> Yojson.Basic.pretty_to_string
  |> print_endline
