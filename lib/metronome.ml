open Raylib

let start (start_bpm : float) =
  let tick = load_sound "assets/metronome.mp3" in
  set_sound_volume tick 0.1;
  let bpm = ref start_bpm in
  let min = 1 in
  let max = 300 in
  let next_time = ref (Unix.gettimeofday ()) in
  let running = ref false in
  let editable = ref false in
  fun () ->
    if !running then (
      let current_time = Unix.gettimeofday () in
      if is_key_pressed Key.Space then running := false
      else if current_time >= !next_time then (
        play_sound tick;
        next_time := Unix.gettimeofday () +. (60. /. !bpm)))
    else if is_key_pressed Key.Space then running := true;

    if is_key_down Key.Up && !bpm < float_of_int max then
      bpm := !bpm +. 1.0
    else if is_key_down Key.Down && !bpm > float_of_int min then
      bpm := !bpm -. 1.0;

    (* removes the extra period after the bpm's float value *)
    let trunc_bpm =
      String.sub (string_of_float !bpm) 0
        (String.length (string_of_float !bpm) - 1)
    in
    let () =
      draw_text "METRONOME" 600 15 10 Color.gray;
      if
        Raygui.button
          (Rectangle.create 670. 10. 25. 20.)
          (if !running then "| |" else "|>")
      then running := not !running;
      bpm :=
        match
          Raygui.spinner
            (Rectangle.create 700. 10. 100. 20.)
            ""
            (int_of_string trunc_bpm)
            ~min ~max !editable
        with
        | vl, true ->
            editable := not !editable;
            float_of_int vl
        | vl, false -> float_of_int vl
    in

    !bpm (* Return the current bpm *)
