open Lwt
let is_on = ref true
let bpm = ref 60.
let beats_played = ref 0
let start_time = ref (Unix.gettimeofday())
let set_bpm beat = bpm := beat
let get_bpm () = !bpm

let reset () =
  let time = Unix.gettimeofday() in
  start_time := time;
  bpm := 0.

let play_tick () =
  let command = "afplay" in
  let sound_file = "./wav_files/metronome-trimmed.wav" in  
  Lwt.async (fun () -> Lwt_process.shell (command ^ " " ^ sound_file) |> Lwt_process.exec >>= fun _ ->
  Lwt.return_unit);
  Lwt.return_unit

let rec start_metronome () = 
  let bpm = get_bpm () in 
  if bpm > 0. then 
    let interval = (60. /. bpm) in 
    let start_time = Unix.gettimeofday () in (* Capture start time before playing tick *)
    play_tick () >>= fun () ->
    let end_time = Unix.gettimeofday () in (* Capture end time after playing tick *)
    let elapsed = end_time -. start_time in (* Calculate elapsed time *)
    let adjusted_interval = max 0. (interval -. elapsed) in (* Adjust interval to account for elapsed time *)
    Lwt_unix.sleep adjusted_interval >>= fun () ->
    start_metronome ()
  else 
    Lwt.return_unit

let start () = Lwt.async (fun () -> start_metronome ())
