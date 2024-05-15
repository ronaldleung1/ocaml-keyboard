val print_string_to_file : string -> string -> unit
val load_array_from_file :
  string -> (string * (float * float * string)) array ref
val data_to_string : string * (float * float * string) -> string
