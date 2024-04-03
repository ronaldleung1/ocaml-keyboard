let start bpm =
  let tick = Raylib.load_sound "assets/metronome-trimmed.wav" in
  let interval = 60. /. bpm in
  let next_time = ref (Unix.gettimeofday () +. interval) in
  fun () ->
    if Unix.gettimeofday () >= !next_time then (
      Raylib.play_sound tick;
      next_time := Unix.gettimeofday () +. interval)
