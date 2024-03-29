(* open Lwt

let notes = [ 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G' ]

let play note note =
  let () =
    Lwt_preemptive.set_bounds (!beats_played + 1, !beats_played + 1)
  in
  Lwt.async (fun () ->
      Lwt_preemptive.detach
        (fun () ->
          let _ =
            Sys.command "afplay ./resources/" ^ note ^ "4.wav"
          in
          ())
        ()
      >>= fun _ -> Lwt.return_unit) *)
