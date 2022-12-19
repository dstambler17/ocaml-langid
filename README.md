# ocaml-langid
Lang ID library for Ocaml

### Project Team: Daniel Stambler, Gurion Marks

## BUILD, AND INSTALL and TEST INSTRUCTIONS
### 1) IMPORTANT: Make sure you have the following non-ocaml depencies
    `models/fst_feature_model_info.json`
    `models/nb_ptc.npy`
    `models/nb_pc.npy`

### 2) IMPORTANT: Make sure you have the following non-ocaml depencies
    `models/fst_feature_model_info.json`
    `models/nb_ptc.npy`
    `models/nb_pc.npy`

### 3) Build and test
    Run `dune build`
    Run `opam install .`

    NOTE FOR MAC USERS: You might need to run `brew install ssl` and `brew install open-blas`
    and then follow the export instructions to get the dependencies to install

    #### EXTREMELY IMPORATANT FOR TESTING REPLACE
    In `tests.ml`, replace the variable let working_dir_path variable with you working path (must be an absolute path)
    See IMPORTANT NOTE at the top of `tests.ml`
    Ex: `/Users/daniel/Documents/ocaml-langid`
    Run `dune test`

#### NOTE ON DEMO ISSUE:
    During our submission, even though the model worked really well on the game, we saw that on the eval mode, it didn't work so well. We speculated that it might be a bug in calling the model. However, there actually was no bug, and the fault was ours for picking terrible edge cases to use for the demo. To clarify, the model doesn't do well on short strings like "Je suis Jean Pierre". However, on longer strings such as "Je suis Jean Pierre et tus?", it does extremely well. Furthermore, capital letters can alter the prediction for short strings. Ex: "hello world" leads to the correct "english" predicition with a confidence of 73, but "Hello World" (as seen in the demo) doesn't work. Again, we apologize for not coming in better examples for this use case.

# Install Instructions
1) opam install cohttp-lwt-unix cohttp-async
2) brew install openssl
   1) Then follow the export instructions
3) opam install lwt_ssl



**1) An overview of the purpose of the project**

 The purpose of the project is to make an opam package for LangID, a package that currently doesn’t exist in the OCaml ecosystem. Given a string, detect what language it's written in as well as the confidence of the underlying model. (similar to this python library: https://github.com/saffsd/langid.py) We will use this library in a command line game that pits the user's language guessing abilities against the LangID model.


    Our project is the OCaml version of this python LangID library: 
    https://github.com/saffsd/langid.py/tree/master/langid

    We are modeling our interface off of this instantiation, and thus our .mli file seeks to approximate the python version, such that users of the package can expect similar performance when using our OCaml implementation.
    
    The command line game is our own original idea, and just a way for us to showcase our implementation of the LangID library
