(lang dune 3.4)
(name ocaml_langid)
(generate_opam_files true)
(authors "Daniel Stambler" "Gurion Marks")
(maintainers "dstambler17@gmail.com" "gurion@gmail.com")
(homepage "https://github.com/dstambler17/ocaml-langid")
(bug_reports "https://github.com/dstambler17/ocaml-langid/issues")
(documentation "https://github.com/dstambler17/ocaml-langid")
(source (github dstambler17/ocaml-langid))
(package
 (name ocaml_langid)
 (allow_empty)
 (synopsis "An OCaml library for Predicting Lang ID Given a string of Text")
 (description "Ocaml implementation of the Python Lang ID library originally 
                written by (Marco Lui, 2011, saffsd@gmail.com).
                This package also includes a command line game with sample usage of LangID")
 (depends
  (ounit2 (>= 2.2.6)) ; for each opam dependency list the version
  (core (>= 0.15.0)) ; `opam list core` will display which version of core you have
  (owl  (>= 1.0.2-1))
  (minicli   (>= 5.0.2))
  (cohttp-async  (>= 5.0.0))
  (cohttp-lwt-unix  (>= 5.0.0)) 
  (lwt  (>= 5.6.1))
  (lwt_ssl  (>= 1.1.3))
  (ppx_deriving (>= 5.2.1))
  (ppx_deriving_yojson (>= 3.6.1))
))