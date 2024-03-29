open Lwt

let notes = [ 'C'; 'D'; 'E'; 'F'; 'G'; 'A'; 'B' ]

let play note =
  (* let () = Lwt_preemptive.set_bounds (!beats_played + 1,
     !beats_played + 1) in *)
  Lwt.async (fun () ->
      Lwt_preemptive.detach
        (fun () ->
          let _ =
            Sys.command
              ("afplay ./assets/notes/" ^ String.make 1 note ^ "5.mp3")
          in
          ())
        ()
      >>= fun _ -> Lwt.return_unit)
