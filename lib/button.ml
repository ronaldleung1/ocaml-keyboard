open Raylib

(* idea for button overlap issue: create a stack of button to keep track
   of. Each button's check for clicks just iterates through the stack to
   see if mouse position is inside the dimension of the button *)
let button_stack : Rectangle.t list ref = ref []

let rec check_collision mouse_point button button_list =
  match button_list with
  | [] -> false
  | h :: t ->
      if check_collision_point_rec mouse_point h then
        if button == h then true else false
      else check_collision mouse_point button t

let create_general_with_key_binding
    ?(draw_text = false)
    ?(opt_color = Color.gray)
    ?(opt_text = "")
    (key_binding : Raylib.Key.t)
    x
    y
    width
    height
    (func : unit -> unit) =
  let rect =
    Raylib.Rectangle.create (float_of_int x) (float_of_int y)
      (float_of_int width) (float_of_int height)
  in
  button_stack := rect :: !button_stack;

  let color = ref opt_color in
  let mouse_point = ref (Vector2.create 0. 0.) in

  fun () ->
    color := opt_color;
    mouse_point := get_mouse_position ();

    (* if mouse click is within the rectangle dimension when
       left-clicked, the corresponding function will be executed *)
    if check_collision !mouse_point rect !button_stack then begin
      if is_mouse_button_pressed MouseButton.Left then begin
        func ()
      end;
      if is_mouse_button_down MouseButton.Left then begin
        color := Color.green
      end
    end;

    (fun key_binding ->
      if is_key_pressed key_binding then begin
        func ()
      end;
      if is_key_down key_binding then begin
        color := Color.green
      end)
      key_binding;

    draw_rectangle
      (int_of_float (Rectangle.x rect))
      (int_of_float (Rectangle.y rect))
      (int_of_float (Rectangle.width rect) - 1)
      (int_of_float (Rectangle.height rect))
      !color;

    (* draws the text of 'note' in the middle of the rectangle when
       optional 'draw_text' is true *)
    if draw_text then
      let text = opt_text in
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

let create
    ?(draw_text = false)
    ?(opt_color = Color.white)
    ?(view_only = false)
    note
    key_list
    string_key_list
    rect
    (instrument : string) =
  button_stack := rect :: !button_stack;

  let sound =
    load_sound ("assets/" ^ instrument ^ "/" ^ note ^ ".mp3")
  in
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

  let note_blocks = ref [] in
  (* (y, height) array *)
  let draw_note_block (pos, length) =
    draw_rectangle
      (int_of_float (Rectangle.x rect))
      (int_of_float (Rectangle.y rect) - pos)
      (int_of_float (Rectangle.width rect) - 1)
      length block_color
  in

  let note_volume = ref 1.0 in
  let fade_note = ref false in

  let play_note () =
    (* plays the sound and stores it in an instance, so its volume can
       be manipulated later *)
    fade_note := false;
    set_sound_volume sound 1.0;
    note_volume := 1.0;
    play_sound sound;
    note_blocks := (0, 0) :: !note_blocks
  in

  let stop_note () =
    (* begin reducing volume of note *)
    fade_note := true
  in

  let fade_duration = 0.25 in
  (* duration in seconds *)
  let steps = 10 in
  let step_delay = fade_duration /. float_of_int steps in
  let next_time = ref (Unix.gettimeofday ()) in

  let fade_out_note () =
    if !fade_note then begin
      let volume_step = 1.0 /. float_of_int steps in
      if !note_volume > 0.0 then begin
        let current_time = Unix.gettimeofday () in
        set_sound_volume sound !note_volume;
        if current_time >= !next_time then begin
          print_endline (string_of_float !note_volume);
          note_volume := !note_volume -. volume_step;
          next_time := current_time +. step_delay
        end
      end
      else begin
        print_endline "stopping sound";
        fade_note := false;
        stop_sound sound;
        set_sound_volume sound 1.0;
        note_volume := 1.0
      end
    end
  in

  fun () ->
    color := opt_color;
    mouse_point := get_mouse_position ();

    (* mouse input *)
    if check_collision !mouse_point rect !button_stack then begin
      if is_mouse_button_pressed MouseButton.Left then begin
        play_note ()
      end;
      if is_mouse_button_down MouseButton.Left then begin
        color := Color.green;
        match !note_blocks with
        | [] -> ()
        | (pos, length) :: t -> note_blocks := (pos, length + 1) :: t
      end;
      if is_mouse_button_released MouseButton.Left then begin
        stop_note ()
      end
    end;

    (* keyboard input *)
    List.iter
      (fun key ->
        begin
          if is_key_pressed key && not view_only then begin
            play_note ()
          end;
          if is_key_released key then begin
            stop_note ()
          end;
          if is_key_down key && not view_only then begin
            color := Color.green;
            match !note_blocks with
            | [] -> ()
            | (pos, length) :: t ->
                note_blocks := (pos, length + 1) :: t
          end
        end)
      key_list;

    (* reduce volume of notes not being played *)
    fade_out_note ();

    (* move note blocks up screen *)
    note_blocks :=
      List.map (fun (pos, length) -> (pos + 1, length)) !note_blocks;

    (* remove notes that are off the screen *)
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
    if draw_text then (
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
      let key_text_color = Color.gold in
      Raylib.(draw_text text text_x text_y 16 text_color);
      let key_code_text = String.concat ", " string_key_list in
      let key_code_text_x = int_of_float (Rectangle.x rect +. 3.) in
      let key_code_text_y =
        int_of_float (Rectangle.y rect +. Rectangle.height rect -. 14.)
      in
      Raylib.draw_text key_code_text key_code_text_x key_code_text_y 14
        key_text_color)
    else ()
