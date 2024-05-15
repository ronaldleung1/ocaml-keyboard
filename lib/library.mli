type t
(** The type representing a library. *)

val empty : t
(** An empty library *)

val is_empty : t -> bool
(** [is_empty library] is whether the [library] is empty (no playlists). *)

val add_new_playlist : Playlist.t -> t -> unit
(** [add_new_playlist playlist library] adds the playlist to the
    [library]. *)

val remove_playlist : string -> t -> unit
(** [remove__playlist playlist_name library] removes all playlists with
    name [playlist_name] from the [library]. *)

val display : t -> string
(** [display library] is a string of playlists of [library] line by
    line. *)

val find_playlist : string -> t -> Playlist.t option
(** [find_playlist name library] is Some playlist within [library] with
    the matching name if it exists, None otherwise. *)

val get_playlists : t -> Playlist.t list
(** [get_playlists library] is a list of all playists in [library]*)
