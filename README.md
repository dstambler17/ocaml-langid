# ocaml-langid: Language Identification for Ocaml

### Daniel Stambler, Gurion Marks

## About ocaml-langid

The OCaml ecosystem currently has no language identification package counterpart similar to [langid](https://github.com/saffsd/langid.py) in python. As two students interested in NLP and translation, we implement langid for OCaml. 

Given a string, detect the language in which it is written, and output the confidence of the most probable(or top-n most probable) languages, according to the model. 
We use this library in a fun command-line game that pits the user's language guessing abilities against the LangID model.

In an effort to be consistent with existing open-source packages, and make our package readily useable by those who may be familar with the popular python instantiation, we model our interface off this existing open-source library.

## Build, install, and test instructions

### 1) Ensure you have the following non-ocaml depencies
* `models/fst_feature_model_info.json`
* `models/nb_ptc.npy`
* `models/nb_pc.npy`

### 2) Build project
Run:
1) `dune build`
2) `opam install .`

NOTE FOR MAC USERS: You might need to `brew install ssl` and `brew install open-blas`. Then follow the export instructions to get the dependencies to install

### 3) Test project
1) Replace the variable `working_dir_path` in `tests/tests.ml` with your (absolute) working path.

    Ex: `let working_dir_path = /Users/daniel/Documents/ocaml-langid`

2) Run `dune test`

## Example usage
### Executable
`dune build` will build the executable `langid.exe` at `_build/default/src/langid.exe`. This can be run for either simple text evaluation of a string, or for our langid game.

#### Canonical
```./_build/default/src/langid.exe` -mode <string> -top_n <int> -input <string> [-h;-help]```

Arguments:
* `-mode` - either `game` or `eval`. Defaults to `eval` if none provided
* `-top_n` - number of predicted languages to output. Defaults to 3.
* `-input` - if "eval" mode used, string to predict language
* `-h` - output argument information

#### Evaluation
```./_build/default/src/langid.exe -mode eval -top_n 3 -input "Earth is beautiful with a bright blue sky and green trees```

#### Game
```./_build/default/src/langid.exe -mode game```

## Notes

### Future features/changes:
The sampler used to generate sentences for the game draws random sample sentences from Wikipedia in any of the possible target languages of the model. We would prefer to switch this paradigm to one in which a random english sentence is generated, and then translated to a target language to be output and for the model to run inference on. The Google Translate API requires authentication, which is not ideal for a program of our style, and we encountered issues with other open-source APIs. The random sentence initializer is also a hurdle, as calls to generative models often require authentication as well. We're actively looking for better options.

### On demo issue:
We encountered an example in our demo in which "Hello World" was classified as Italian. While caught off guard by this, we realized that, as the model works by accumulating probability in transition states between ASCII characters, the mix of short sentence and capitalization throw off the prediction (both "hello world" and "Hello world" are correctly categorized as English). This in fact is not a bug, but a feature :)

Note that the model works incredibly well in the game setting as the sentence length is necessarily longer and thus the model is better able to make assumptions based off character transitions.

Command-line args have also been fixed to more elegantly handle errors, and automatically output help options if there is an issue with the input given to the program.