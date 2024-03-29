open Lwt

let is_on = Atomic.make true
let bpm = Atomic.make 0.
let beats_played = ref 0
let start_time = ref (Unix.gettimeofday ())
let set_bpm beat = Atomic.set bpm beat
let get_bpm () = Atomic.get bpm

let reset () =
  let time = Unix.gettimeofday () in
  start_time := time;
  Atomic.set bpm 0. (* Reset to default BPM instead of 0. *)

let play_tick () =
  let () =
    Lwt_preemptive.set_bounds (!beats_played + 1, !beats_played + 1)
  in
  Lwt.async (fun () ->
      Lwt_preemptive.detach
        (fun () ->
          let _ = Sys.command "afplay ./assets/metronome-trimmed.wav" in
          ())
        ()
      >>= fun _ -> Lwt.return_unit)

let rec start_metronome start_time () =
  if Atomic.get is_on then
    let bpm = get_bpm () in
    if bpm > 0. then (
      let interval = 60. /. bpm in
      while Unix.gettimeofday () < start_time do
        ()
      done;
      (* Loop until Unix.gettimeofday () is start_time *)
      play_tick ();
      beats_played := !beats_played + 1;
      let next_time = Unix.gettimeofday () +. interval in
      (* Capture end time after playing tick *)
      start_metronome next_time ())
    else Lwt.return_unit
  else Lwt.return_unit
