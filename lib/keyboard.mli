val init_keyboard :
  int ->
  Raylib.Rectangle.t ->
  string ->
  ?view_only:bool ->
  bool ->
  unit ->
  (unit -> unit) list
(** [init_keyboard init_octave rect instrument ?(view_only = false) 
    sustain_on ()]
    draws the keyboard within the specified region of [rect] and creates
    the corresponding keyboard buttons for the specific [instrument]
    with [sustain_on] either true or false the option for the keys to be
    on [view_only]. The keyboard is limited to keys in the
    [init_octave]. Requires init_octave to be in [0, 7]. Raises failure
    if called more than once. Returns the keyboard as a list of
    interactive keys. *)

val refresh :
  Raylib.Rectangle.t ->
  string ->
  bool ->
  bool ->
  bool ->
  bool ->
  bool ->
  (unit -> unit) list
(** [refresh rect instrument changed_instrument changed_view view_only 
    changed_sustain sustain_on]
    redraws the keyboard if the octave, instrument, sustain setting, or
    view setting has changed. Draws with dimensions provided by rect,
    the instrument, the sustain setting, and the view_only setting.
    Returns the keyboard as a list of interactive keys. *)
