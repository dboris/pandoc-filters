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

let parse_attrs str =
  String.split_on_char ',' str
  |> List.map @@ fun str ->
    match String.split_on_char ':' str with
    | k :: v :: [] -> k, v
    | _ -> failwith "Attrs should be key-value pairs"

let () =
  let json = Yojson.Basic.from_channel stdin in
  let p = Pandoc.of_json json in
  let attrs =
    try parse_attrs (Pandoc.meta_string p "remove-attrs")
    with Not_found ->
      failwith "Usage: pandoc -M remove-attrs=k1:v1,k2:v2,..."
  in
  (* let s = Yojson.Basic.pretty_to_string json in
  prerr_endline s; *)
  p
  |> Pandoc.map
      ~block:(block (contains attrs))
      ~inline:(inline (contains attrs))
  |> Pandoc.to_json
  |> Yojson.Basic.pretty_to_string
  |> print_endline
