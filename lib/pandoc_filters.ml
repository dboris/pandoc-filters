let kv_mem xs k v =
  List.exists (fun (k', v') -> String.equal k k' && String.equal v v') xs

let contains filter_attrs (id, cls, kvs) =
  kv_mem filter_attrs "id" id ||
  List.exists Fun.id (List.map (kv_mem filter_attrs "class") cls) ||
  kvs
  |> List.map (fun (k, v) -> kv_mem filter_attrs k v)
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
