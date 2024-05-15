type t
(** The type of a playlist. *)

val create : string -> t
(** [create name] is a playlist called [name]. *)

val get_name : t -> string
(** [get_name playlist] is the name of the [playlist]. *)

val is_empty : t -> bool
(** [is_empty playlist] is whether the playlist is empty. *)

val add_song : t -> Song.t -> unit
(** [add_song playlist song] adds the [song] to the [playlist]. *)

val remove_song : t -> string -> unit
(** [remove_song playlist name] removes the playlist called [name] from
    [playlist]. *)

val contains : t -> string -> bool
(** [contains playlist name] is whether name is the name of a playlist
    in [playlist]. *)

val total_duration : t -> string
(** [total_duration playlist] is string detailing the total duration of
    the playlist in hours:minutes. *)

val display : t -> string
(** [display playlist] is a string of the songs of [playlist] with their
    details listed out line by line. *)

val get_songs : t -> Song.t list
(** [get_songs playlist] is a list of the songs contained within
    [playlist]. *)
