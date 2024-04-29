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

val create :
  ?draw_text:bool ->
  ?opt_color:Raylib.Color.t ->
  string ->
  Raylib.Key.t list ->
  string list ->
  Raylib.Rectangle.t ->
  string ->
  unit ->
  unit
