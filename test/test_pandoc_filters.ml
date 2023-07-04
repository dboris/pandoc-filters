module F = Pandoc_filters
module A = Alcotest

let test_kv_mem () =
  let lst = ["k1", "v1"; "k2", "v2"] in

  F.kv_mem lst "k1" "v1" |> A.check A.bool "kv_mem first match" true;
  F.kv_mem lst "k2" "v2" |> A.check A.bool "kv_mem last match" true;
  F.kv_mem lst "k2" "v" |> A.check A.bool "kv_mem no value match" false;
  F.kv_mem lst "x" "m" |> A.check A.bool "kv_mem no match" false;
  F.kv_mem [] "k2" "v2" |> A.check A.bool "kv_mem empty list" false;
  F.kv_mem ["a", "v1"; "a", "v2"] "a" "v2"
  |> A.check A.bool "kv_mem multi key" true

let test_contains () =
  F.contains ["class", "foo"] ("myid", ["foo"; "bar"], [])
  |> A.check A.bool "contains class" true;

  F.contains ["class", "x"; "class", "bar"] ("myid", ["foo"; "bar"], [])
  |> A.check A.bool "contains multi class" true;

  F.contains ["class", "x"] ("myid", ["foo"; "bar"], [])
  |> A.check A.bool "contains no match" false

let suite =
  [ "kv_mem", `Quick, test_kv_mem
  ; "contains", `Quick, test_contains
  ]

let () = A.run "test_pandoc_filters" [ "pandoc_filters", suite ]
