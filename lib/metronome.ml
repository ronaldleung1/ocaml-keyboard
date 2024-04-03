let start bpm () =
  let tick = Raylib.load_sound "assets/metronome-trimmed.wav" in
  let rec loop start_time =
    if bpm > 0. then (
      let interval = 60. /. bpm in
      while Unix.gettimeofday () < start_time do
        ()
      done;
      (* Loop until Unix.gettimeofday () is start_time *)
      Raylib.play_sound tick;
      let next_time = Unix.gettimeofday () +. interval in
      (* Capture end time after playing tick *)
      loop next_time)
  in
  loop (Unix.gettimeofday () +. 1.)
