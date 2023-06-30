(lang dune 3.5)

(name pandoc_filters)

(generate_opam_files true)

(source (github dboris/pandoc-filters))
(authors "Boris D. <borisd@gmx.com>")
(maintainers "Boris D. <borisd@gmx.com>")

(license ISC)

(package
 (name pandoc_filters)
 (synopsis "Pandoc filters")
 (depends ocaml dune pandoc yojson)
 (tags (pandoc "pandoc filters")))
