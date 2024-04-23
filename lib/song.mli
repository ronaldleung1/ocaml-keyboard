type t

val create : string -> string -> int -> t
val title : t -> string
val artist : t -> string
val duration : t -> int
val seconds_to_minutes : int -> int * int
val time_to_string : int * int -> string
val to_string : t -> string
val to_string_detailed : t -> string
