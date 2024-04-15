val init_keyboard : Raylib.Rectangle.t -> int -> (unit -> unit) list
(** [init_keyboard rect init_octave] draws the keyboard and creates the
    corresponding keyboard buttons. The keyboard is limited to keys in
    the init_octave. Requires init_octave to be in [0, 7]. *)
