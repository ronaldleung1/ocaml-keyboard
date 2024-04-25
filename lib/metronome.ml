open Raylib

let start (start_bpm : float) =
  let tick = load_sound "assets/metronome-trimmed.wav" in
  set_sound_volume tick 0.5;
  let bpm = ref start_bpm in
  let next_time = ref (Unix.gettimeofday ()) in
  let running = ref true in
  fun () ->
    if !running then (
      if is_key_down Key.Up then( bpm := !bpm +. 1.0;
        (* Unix.sleep 1;
        while is_key_down Key.Up do 
          bpm := !bpm +. 1.0
        done *)
      )
      else if is_key_down Key.Down then bpm := !bpm -. 1.0
      else if is_key_pressed Key.Space then running := false
      else if Unix.gettimeofday () >= !next_time then (
        play_sound tick;
        next_time := Unix.gettimeofday () +. (60. /. !bpm)))
    else if is_key_pressed Key.Space then running := true;

    (* removes the extra period after the bpm's float value *)
    let trunc_bpm =
      String.sub (string_of_float !bpm) 0
        (String.length (string_of_float !bpm) - 1)
    in
    draw_text ("BPM: " ^ trunc_bpm) 700 10 16 Raylib.Color.gold
