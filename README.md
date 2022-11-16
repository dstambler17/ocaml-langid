# ocaml-langid
Lang ID library for Ocaml

### Project Team: Gurion Marks, Daniel Stambler

**1) An overview of the purpose of the project**

 The purpose of the project is to make an opam package for LangID, a package that currently doesn’t exist in the OCaml ecosystem. Given a string, detect what language it's written in as well as the confidence of the underlying model.  (similar to this python library: https://github.com/saffsd/langid.py) We will use this library in a command line game.

**2) A list of libraries you plan on using**

We plan on using `OCaml Core`, `OCaml torch` `core_unix`, `core_unix.sys_unix` `stdio` `yojson`, `core_unix.command_unix` and `uutf` (an ocaml unicode character package)

**3) .mli file**
- See langid.mli 

**4) Include a mock of a use of your application, along the lines of the Minesweeper example above but showing the complete protocol.**
- See examples of use cases provided in langid.mli

**5) Make sure you have installed and verified any extra libraries will in fact work on your computer setup, by running their tutorial examples.**

    We installed ocaml torch via `opam install torch` and then followed the example tutorial
    shown here: https://ocaml.org/p/torch/0.9

```
    (* Create two tensors to store model weights. *)
    let ws = Tensor.zeros [10; 10] ~requires_grad:true in
    let bs = Tensor.zeros [10] ~requires_grad:true in
    let model xs = Tensor.(mm xs ws + bs) in
```
Which produced the following outputs in the utop top loop:

```
val ws : Tensor.t = 
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0
[ CPUFloatType{10,10} ]

val bs : Tensor.t = 
 0
 0
 0
 0
 0
 0
 0
 0
 0
 0
[ CPUFloatType{10} ]

val model : Tensor.t -> Tensor.t = <fun>
```

We also installed uutf (https://erratique.ch/software/uutf/doc/Uutf/index.html) via `opam install uutf`
and got the following tutorial example to work:

```
let lines ?encoding (src : [`Channel of in_channel | `String of string]) =
let rec loop d buf acc = match Uutf.decode d with
| `Uchar u ->
    begin match Uchar.to_int u with
    | 0x000A ->
        let line = Buffer.contents buf in
        Buffer.clear buf; loop d buf (line :: acc)
    | _ ->
        Uutf.Buffer.add_utf_8 buf u; loop d buf acc
    end
| `End -> List.rev (Buffer.contents buf :: acc)
| `Malformed _ -> Uutf.Buffer.add_utf_8 buf Uutf.u_rep; loop d buf acc
| `Await -> assert false
in
let nln = `Readline (Uchar.of_int 0x000A) in
loop (Uutf.decoder ~nln ?encoding src) (Buffer.create 512) []
```

Which produced the following output in the utop top loop:
```
val lines :
  ?encoding:[< Uutf.decoder_encoding ] ->
  [ `Channel of in_channel | `String of string ] -> string list = <fun>
```

**6) Also include a brief list of what order you will implement features.**
1) We will first work on importing a pretrained model from a file into OCaml Torch. 
2) We will ensure that we are able to use the model to classify text from raw input. We will extend functionality to classify multiple sentences
3) We will work on using text coming from a file given a path, and output top_n predictions for the language of that file
4) We will implement a LangID game for users to try to beat the model using preloaded text snippets and ground truth. 

**7) If your project is an OCaml version of some other app in another language or a projust you did in another course etc please cite this other project. In general any code that inspired your code needs to be cited in your submissions.**
    Our project is the OCaml version of this python LangID library: 
    https://github.com/saffsd/langid.py/tree/master/langid

    We are modeling our interface off of this instantiation, and thus our .mli file seeks to approximate the python version, such that users of the package can expect similar performance when using our OCaml implementation.