(* adapted from
   https://www.raylib.com/examples/textures/loader.html?name=textures_sprite_button *)
open Raylib

let create note rect =
  let tick = load_sound ("assets/notes/" ^ note ^ ".mp3") in
  let color = ref Color.white in
  let mouse_point = ref (Vector2.create 0. 0.) in
  (* may be best to move to main.ml *)
  fun () ->
    color := Color.white;
    mouse_point := get_mouse_position ();

    if check_collision_point_rec !mouse_point rect then (
      if is_mouse_button_pressed MouseButton.Left then play_sound tick;
      if is_mouse_button_down MouseButton.Left then color := Color.green);

    draw_rectangle
      (int_of_float (Rectangle.x rect))
      (int_of_float (Rectangle.y rect))
      (int_of_float (Rectangle.width rect))
      (int_of_float (Rectangle.height rect))
      !color
