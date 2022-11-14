(* 
Load model file from path, get back a string representation of the model
*)
val load_model_file: string -> string

(* 
Load model from weights    
*)
val load_model_weights: string -> 'a Torch_core.Wrapper.Module

