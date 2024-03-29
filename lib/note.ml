open Lwt

let play () =
  let () =
    Lwt_preemptive.set_bounds (!beats_played + 1, !beats_played + 1)
  in
  Lwt.async (fun () ->
      Lwt_preemptive.detach
        (fun () ->
          let _ =
            Sys.command "afplay ./wav_files/metronome-trimmed.wav"
          in
          ())
        ()
      >>= fun _ -> Lwt.return_unit)
