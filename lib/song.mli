type t

val create : string -> string -> int -> t
val title : t -> string
val artist : t -> string
val duration : t -> int
