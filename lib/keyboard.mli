val init_keyboard : int -> Raylib.Rectangle.t -> string -> (unit -> unit) list
(** [init_keyboard rect init_octave instrument] draws the keyboard forand creates the
    corresponding keyboard buttons for the specific instrument. The keyboard is limited to keys in
    the init_octave. Requires init_octave to be in [0, 7]. *)
