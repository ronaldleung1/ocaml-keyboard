val is_on : bool ref
val bpm : float ref
val beats_played : int ref
val start_time : float ref
val set_bpm : float -> unit
val get_bpm : unit -> float
val reset : unit -> unit
val play_tick : unit -> unit Lwt.t
val start_metronome : unit -> unit Lwt.t
val start : unit -> unit