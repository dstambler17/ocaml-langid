# ocaml-langid
Lang ID library for Ocaml


1) An overview of the purpose of the project
2) A list of libraries you plan on using
3) Commented module type declarations (.mli files) which will provide you with an initial specification to code to
- You can obviously change this later and don’t need every single detail filled out
- But, do include an initial pass at key types and functions needed and a brief comment if the meaning of a function is not clear.
4) Include a mock of a use of your application, along the lines of the Minesweeper example above but showing the complete protocol.
- See example of use cases in langid.mli
5) Make sure you have installed and verified any extra libraries will in fact work on your computer setup, by running their tutorial examples.
- We have Torch installed, which should be the only external library necessary other than Core. 
6) Also include a brief list of what order you will implement features.
- We will first work on importing a pretrained model from a file into OCaml Torch. 
- Second, we will ensure that we are able to use the model to classify text from raw input. We will extend functionality to classify multiple sentences
- Third, we will work on using text coming from a file given a path, and output top_n predictions for the language of that file
- Fourth, we will implement a LangID game for users to try to beat the model using preloaded text snippets and ground truth. 
7) If your project is an OCaml version of some other app in another language or a projust you did in another course etc please cite this other project. In general any code that inspired your code needs to be cited in your submissions.
8) You may also include any other information which will make it easier to understand your project.
   