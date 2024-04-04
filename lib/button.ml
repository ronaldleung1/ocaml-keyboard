(* adapted from
   https://www.raylib.com/examples/textures/loader.html?name=textures_sprite_button *)
open Raylib

let create =
  let sound = load_sound "assets/notes/C5.mp3" in
  let btn_action = ref false in
  let btn_bounds = Rectangle.create 0. 0. 20. 100. in
  let btn_state = ref 0 in
  let color = ref Color.white in
  (* Button action should be activated *)
  let mouse_point = ref (Vector2.create 0. 0.) in
  (* may be best to move to main.ml *)
  fun () ->
    color := Color.white;
    mouse_point := get_mouse_position ();
    btn_action := false;

    if check_collision_point_rec !mouse_point btn_bounds then
      if is_mouse_button_down MouseButton.Left then (
        btn_action := true;
        btn_state := 2)
      else btn_state := 1
        (* if is_mouse_button_released MouseButton.Left then () *)
    else btn_state := 0;

    if !btn_action then (
      color := Color.green;
      play_sound sound);
    print_endline (string_of_int !btn_state);

    draw_rectangle
      (int_of_float (Rectangle.x btn_bounds))
      (int_of_float (Rectangle.y btn_bounds))
      (int_of_float (Rectangle.width btn_bounds))
      (int_of_float (Rectangle.height btn_bounds))
      !color
