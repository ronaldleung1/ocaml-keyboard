val is_on : bool Atomic.t
val bpm : float Atomic.t
val beats_played : int ref
val start_time : float ref
val set_bpm : float -> unit
val get_bpm : unit -> float
val reset : unit -> unit
val play_tick : unit -> unit
val start_metronome : float -> unit -> unit Lwt.t
