type t

val create : string -> t
val get_name : t -> string
val add_song : t -> Song.t -> unit
val remove_song : t -> string -> unit
val contains : t -> string -> bool
val total_duration : t -> string
val display : t -> string
