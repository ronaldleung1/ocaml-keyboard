open Raylib

val create_general_with_key_binding :
  ?draw_text:bool ->
  ?opt_color:Color.t ->
  ?opt_text:string ->
  Key.t ->
  int ->
  int ->
  int ->
  int ->
  (unit -> unit) ->
  unit ->
  unit
(** [create_general_with_key_binding
    ?(draw_text = false)
    ?(opt_color = Color.gray)
    ?(opt_text = "")
    key_binding
    x
    y
    width
    height
    func]
    creates a rectangular button with position specified by x, y, and
    dimensions specified by width and height. Requires x, y, width,
    height to be greater than 0. The button, when interacted with,
    through clicking the rectangular shape, or Pressing the key with
    [key_binding], will trigger function specified in [func]. Requires
    [key_binding] to be a single letter on a standard keyboard. You
    maybe choose to include a text that can be printed on the button if
    [draw_text] is true *)

val create :
  ?draw_text:bool ->
  ?opt_color:Raylib.Color.t ->
  ?view_only:bool ->
  string ->
  Raylib.Key.t list ->
  string list ->
  Raylib.Rectangle.t ->
  string ->
  unit ->
  unit
