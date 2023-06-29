let block f =
  let open Pandoc in
  function
  | BulletList _
  | OrderedList _
  | BlockQuote _
  | DefinitionList _ ->
    None
  | CodeBlock (attr, _) when f attr ->
    Some []
  | Header (_, attr, _) when f attr ->
    Some []
  | Div (attr, _) when f attr ->
    Some []
  | Table (attr, _, _, _, _, _) when f attr ->
    Some []
  | Figure (attr, _, _) when f attr ->
    Some []
  (* | Para _
  | Plain _
  | LineBlock _ *)
  | b -> Some [b]

let contains_assoc xs k v =
  List.mem_assoc k xs && String.equal v (List.assoc k xs)

let contains filter_attrs (id, cls, kvs) =
  contains_assoc filter_attrs "id" id
  || List.exists Fun.id (List.map (contains_assoc filter_attrs "class") cls)
  || kvs
      |> List.map (fun (k, v) -> contains_assoc filter_attrs k v)
      |> List.exists Fun.id

let parse_attrs str =
  String.split_on_char ',' str
  |> List.map @@ fun str ->
    match String.split_on_char ':' str with
    | k :: v :: [] -> k, v
    | _ -> failwith "Attrs should be key-value pairs"

let () =
  let p = Pandoc.of_json (Yojson.Basic.from_channel stdin) in
  let attrs =
    try parse_attrs (Pandoc.meta_string p "skip-attrs")
    with Not_found ->
      failwith "Usage: pandoc -M skip-attrs=k1:v1,k2:v2,..."
  in
  assert (List.length attrs > 0);
  (* attrs
  |> List.iter (fun (k, v) -> Printf.eprintf "%s = %s\n" k v);
  flush stderr; *)
  p
  |> Pandoc.map_blocks (block (contains attrs))
  |> Pandoc.to_json
  |> Yojson.Basic.pretty_to_string
  |> print_endline
