type t
(** The type of song. *)

val create : string -> string -> int -> t
(** [create title artist duration] is a song named [title], by [artist],
    with length [duration]. *)

val title : t -> string
(** [title song] is the string of the name of the [song]. *)

val artist : t -> string
(** [artist song] is a string of the artist of the [song]. *)

val duration : t -> int
(** [duration song] is the duration of the [song] in seconds. *)

val seconds_to_minutes : int -> int * int
(** [seconds_to_minutes seconds] is a tuple of the minutes within
    [seconds] when [seconds] is diveded by 60 followed by the seconds
    remaining with [seconds] mod 60. *)

val time_to_string : int * int -> string
(** [time_to_string tuple] is a string representing minutes:seconds with
    minutes padded with a 0 of needed, where the first value in [tuple]
    is minutes and the second is seconds. *)

val to_string : t -> string
(** [to_string song] is a string represnting the details of song in the
    form "title, artist, duration" *)

val to_string_detailed : t -> string
(** [to_string_detailed song] is a string represnting the details of
    song in the form "Title: <title>, Artists: <artist>, Duration:
    <duration>" *)
