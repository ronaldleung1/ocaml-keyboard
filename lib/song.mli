type t

val create : string -> string -> int -> t
val title : t -> string
val artist : t -> string
val duration : t -> int
val to_string : t -> string
val to_string_detailed : t -> string
