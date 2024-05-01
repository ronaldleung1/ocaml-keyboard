val curr_octave : int ref
(** [curr_octave] is the current octave of the keyboard. curr_octave
    must be in [0,7] *)

val init_keyboard :
  int -> Raylib.Rectangle.t -> string -> (unit -> unit) list
(** [init_keyboard init_octave rect instrument] draws the keyboard
    forand creates the corresponding keyboard buttons for the specific
    instrument. The keyboard is limited to keys in the init_octave.
    Requires init_octave to be in [0, 7]. Raises failure if called more
    than once *)

val init_increase_octave_key : unit -> unit
(** [init_increase_octave_key ()] creates the increase octave button. *)

val init_decrease_octave_key : unit -> unit
(** [init_decrease_octave_key ()] creates the decrease octave button. *)

val refresh :
  Raylib.Rectangle.t -> string -> bool -> (unit -> unit) list
(** [refresh rect instrument changed_instrument] redraws the keyboard if
    the octave or the instrument has changed. Draws with dimensions
    provided by rect, the instrument, and whether the input instrument
    was different from last one. Raises failure if called before
    init_keyboard *)
