open Raylib

let create
    ?(draw_text = false)
    ?(opt_color = Color.white)
    note
    key_list
    rect =
  let sound = load_sound ("assets/notes/" ^ note ^ ".mp3") in
  let color = ref opt_color in
  let mouse_point = ref (Vector2.create 0. 0.) in

  let block_color =
    match String.sub note 0 1 with
    | "A" -> Color.red
    | "B" -> Color.orange
    | "C" -> Color.yellow
    | "D" -> Color.green
    | "E" -> Color.blue
    | "F" -> Color.purple
    | "G" -> Color.pink
    | _ -> Color.white
  in

  (* may be best to move to main.ml *)
  let note_blocks = ref [] in
  (* (y, height) array *)
  let draw_note_block (pos, length) =
    draw_rectangle
      (int_of_float (Rectangle.x rect))
      (int_of_float (Rectangle.y rect) - pos)
      (int_of_float (Rectangle.width rect) - 1)
      length block_color
  in

  let play_note () =
    play_sound sound;
    note_blocks := (0, 0) :: !note_blocks
  in

  fun () ->
    color := opt_color;
    mouse_point := get_mouse_position ();

    if check_collision_point_rec !mouse_point rect then begin
      if is_mouse_button_pressed MouseButton.Left then begin
        play_note ()
      end;
      if is_mouse_button_down MouseButton.Left then begin
        color := Color.green;
        match !note_blocks with
        | [] -> ()
        | (pos, length) :: t -> note_blocks := (pos, length + 1) :: t
      end
    end;

    List.iter
      (fun key ->
        begin
          if is_key_pressed key then begin
            play_note ()
          end;
          if is_key_down key then begin
            color := Color.green;
            match !note_blocks with
            | [] -> ()
            | (pos, length) :: t ->
                note_blocks := (pos, length + 1) :: t
          end
        end)
      key_list;

    (* remove notes that are off the screen *)
    note_blocks :=
      List.map (fun (pos, length) -> (pos + 1, length)) !note_blocks;

    note_blocks :=
      List.filter
        (fun (pos, length) ->
          pos - length < int_of_float (Rectangle.y rect))
        !note_blocks;

    List.iter (fun note -> draw_note_block note) !note_blocks;

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
