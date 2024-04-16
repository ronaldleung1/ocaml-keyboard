type t

val empty : t
val add_new_playlist : Playlist.t -> t -> unit
val remove_playlist : string -> t -> unit
val display : t -> string
val find_playlist : string -> t -> Playlist.t option
