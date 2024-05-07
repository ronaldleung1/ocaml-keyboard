type t

val empty : t
val is_empty : t -> bool
val add_new_playlist : Playlist.t -> t -> unit
val remove_playlist : string -> t -> unit
val display : t -> string
val find_playlist : string -> t -> Playlist.t option
val get_playlists : t -> Playlist.t list
