val print_string_to_file : string -> string -> unit
(** [print_string_to_file filename str] prints [str] to the file named
    [filename] for saving the contents of a preset after closing the
    applications *)

val load_array_from_file :
  string -> (string * (float * float * string)) array ref
(** [load_array_from_file filename] is a mutable array of a tuple
    containing the name of a preset followed by its metronome bpm,
    volume, and instrument *)

val data_to_string : string * (float * float * string) -> string
(** [data_to_string data_tuple] is a string concatenating the string
    forms of the data in [data_tuple] which contains the preset name,
    metronome bpm, volume, and the instrument of the preset. *)
