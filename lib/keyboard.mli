val curr_octave : int ref
(** [curr_octave] is the current octave of the keyboard. *)

val init_keyboard : int -> Raylib.Rectangle.t -> string -> (unit -> unit) list
(** [init_keyboard rect init_octave instrument] draws the keyboard forand creates the
    corresponding keyboard buttons for the specific instrument. The keyboard is limited to keys in
    the init_octave. Requires init_octave to be in [0, 7]. *)

val init_increase_octave_key : unit -> unit
val init_decrease_octave_key : unit -> unit

val refresh : Raylib.Rectangle.t -> (unit -> unit) list
(** [init_increase_octave_key ()] creates the increase octave button.
    [init_decrease_octave_key ()] creates the decrease octave button.
    [refresh rect] redraws the keyboard. *)
