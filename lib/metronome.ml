open Raylib

let start (start_bpm : float) =
  let tick = load_sound "assets/metronome.mp3" in
  set_sound_volume tick 0.1;
  let bpm = ref start_bpm in
  let next_time = ref (Unix.gettimeofday ()) in
  let running = ref false in
  fun () ->
    if !running then (
      let current_time = Unix.gettimeofday () in
      if is_key_pressed Key.Space then running := false
      else if current_time >= !next_time then (
        play_sound tick;
        next_time := Unix.gettimeofday () +. (60. /. !bpm)))
    else if is_key_pressed Key.Space then running := true;

    if is_key_down Key.Up then bpm := !bpm +. 1.0
    else if is_key_down Key.Down then bpm := !bpm -. 1.0;

    (* removes the extra period after the bpm's float value *)
    let trunc_bpm =
      String.sub (string_of_float !bpm) 0
        (String.length (string_of_float !bpm) - 1)
    in
    let () =
      bpm :=
        match
          Raygui.spinner
            (Rectangle.create 700. 10. 100. 20.)
            "BPM"
            (int_of_string trunc_bpm)
            ~min:1 ~max:300 true
        with
        | vl, _ -> float_of_int vl
    in

    !bpm (* Return the current bpm *)
