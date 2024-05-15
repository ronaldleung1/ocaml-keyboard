type t
(** Type of the instrument. *)

val get_name : t -> string
(** [get_name instrument] is a string of the name of the instrument *)

val create : string -> t
(** [create name] is the instrument with the specified name]*)
