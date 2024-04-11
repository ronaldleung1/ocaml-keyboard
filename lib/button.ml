open Raylib

let create ?(draw_text = false) ?(opt_color = Color.white) note rect =
  let tick = load_sound ("assets/notes/" ^ note ^ ".mp3") in
  let color = ref opt_color in
  let mouse_point = ref (Vector2.create 0. 0.) in
  (* may be best to move to main.ml *)
  fun () ->
    color := opt_color;
    mouse_point := get_mouse_position ();

    if check_collision_point_rec !mouse_point rect then (
      if is_mouse_button_pressed MouseButton.Left then play_sound tick;
      if is_mouse_button_down MouseButton.Left then color := Color.green);

    draw_rectangle
      (int_of_float (Rectangle.x rect))
      (int_of_float (Rectangle.y rect))
      (int_of_float (Rectangle.width rect) - 1)
      (int_of_float (Rectangle.height rect))
      !color;

    (* draws the text of 'note' in the middle of the rectangle when
       optional 'draw_text' is true *)
    if draw_text then
      let text = note in
      let text_width = measure_text text 20 in
      let text_x =
        int_of_float
          (Rectangle.x rect
          +. (Rectangle.width rect /. 2.)
          -. (float_of_int text_width /. 2.))
      in
      let text_y =
        int_of_float
          (Rectangle.y rect +. (Rectangle.height rect /. 2.) -. 10.)
      in
      let text_color =
        if !color = Color.black then Color.white else Color.black
      in
      Raylib.(draw_text text text_x text_y 16 text_color)
    else ()
