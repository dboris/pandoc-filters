module F = Pandoc_filters

let lst = ["k1", "v1"; "k2", "v2"]

let test_contains_assoc () =
  F.contains_assoc lst "k1" "v1"
  |> Alcotest.(check bool "contains_assoc first match" true);
  F.contains_assoc lst "k2" "v2"
  |> Alcotest.(check bool "contains_assoc last match" true);
  F.contains_assoc lst "k2" "v"
  |> Alcotest.(check bool "contains_assoc no value match" false);
  F.contains_assoc lst "x" "m"
  |> Alcotest.(check bool "contains_assoc no match" false);
  F.contains_assoc [] "k2" "v2"
  |> Alcotest.(check bool "contains_assoc empty list" false)

let suite =
  [ "contains_assoc", `Quick, test_contains_assoc ]

let () = Alcotest.run "test_pandoc_filters" [ "pandoc_filters", suite ]
