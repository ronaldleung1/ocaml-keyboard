val curr_octave : int ref
(** [curr_octave] is the current octave of the keyboard. Octave cannot
    go lower than 1 or go higher than 7 (C7 highest). *)

val init_increase_button : unit -> unit
(** [init_increase_button] creates a button that increases the octave
    when clicked on or when + is pressed. Updates the curr_octave
    consistent with its invariant: increases by 1 or stays the same when
    reaching the upper bound. *)

val init_decrease_button : unit -> unit
(** [init_decrease_button] creates a button that decreases the octave
    when clicked on or when - is pressed. Updates the curr_octave
    consistent with its invariant: decreases by 1 or stays the same when
    reaching the lower bound. *)

val draw_octave_text : unit -> unit
(** [draw_octave_text] writes the word "Octave" on the GUI. *)
