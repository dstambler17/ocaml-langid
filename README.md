# ocaml-langid
Lang ID library for Ocaml


**1) An overview of the purpose of the project**
 The purpose of the project is to make an opam package for LangID, a package that currently doesn’t exist in the OCaml ecosystem. Given a string, detect what language it's written in as well as the confidence of the underlying model.  (similar to this python library: https://github.com/saffsd/langid.py) We will use this library in a command line game.
**2) A list of libraries you plan on using**
We plan on using `OCaml Core`, `OCaml torch` Ocaml Unicode character packages

**3) .mli file**
- See langit.mli 
**4) Include a mock of a use of your application, along the lines of the Minesweeper example above but showing the complete protocol.**
- See example of use cases shown in langid.mli
**5) Make sure you have installed and verified any extra libraries will in fact work on your computer setup, by running their tutorial examples.**
    We installed ocaml torch via `opam install torch` and then followed the example tutorial
    shown here: https://ocaml.org/p/torch/0.9

```
    (* Create two tensors to store model weights. *)
    let ws = Tensor.zeros [image_dim; label_count] ~requires_grad:true in
    let bs = Tensor.zeros [label_count] ~requires_grad:true in

    let model xs = Tensor.(mm xs ws + bs) in
    for index = 1 to 100 do
        (* Compute the cross-entropy loss. *)
        let loss =
        Tensor.cross_entropy_for_logits (model train_images) ~targets:train_labels
        in

        Tensor.backward loss;

        (* Apply gradient descent, disable gradient tracking for these. *)
        Tensor.(no_grad (fun () ->
            ws -= grad ws * f learning_rate;
            bs -= grad bs * f learning_rate));

        (* Compute the validation error. *)
        let test_accuracy =
        Tensor.(argmax (model test_images) = test_labels)
        |> Tensor.to_kind ~kind:(T Float)
        |> Tensor.sum
        |> Tensor.float_value
        |> fun sum -> sum /. test_samples
        in
        printf "%d %f %.2f%%\n%!" index (Tensor.float_value loss) (100. *. test_accuracy);
    done
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