open Music

let screenWidth = 800
let screenHeight = 450

let setup () =
  let open Raylib in
  init_window screenWidth screenHeight "OCaml Keyboard";
  init_audio_device ();

  (* let music = load_sound "assets/metronome-trimmed.wav" in

     play_sound music; *)
  let metronome = Metronome.start 60. in

  set_target_fps 60;
  metronome

let rec loop metronome =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.gray;
    draw_rectangle 0 0 20 100 Color.white;
    draw_rectangle 25 0 20 100 Color.white;
    draw_rectangle 50 0 20 100 Color.white;
    draw_text "Welcome to OCaml Music!" 190 200 20 Color.white;

    metronome ();
    end_drawing ();
    loop metronome

let () =
  let metronome = setup () in
  loop metronome

(* open Music open Domainslib

   let print_notes pressed_note = List.iter (fun note -> if Char.equal
   note (Char.uppercase_ascii pressed_note) then (
   ANSITerminal.print_string [ ANSITerminal.green; ANSITerminal.on_black
   ] (String.make 1 note); Note.play note) else
   ANSITerminal.print_string [ ANSITerminal.white; ANSITerminal.on_black
   ] (String.make 1 note)) Note.notes; print_newline ()

   let () = print_endline "Welcome to Caml Music!"; print_string "Enter
   a beats per minute for your metronome: "; let bpm = read_line () in
   Metronome.set_bpm (float_of_int (int_of_string bpm)); print_endline
   "Enter a note (A-G), or enter the tempo for the metronome (in \ beats
   per minute):"; print_notes ' '

   let play_note note = if String.length note = 1 then let pressed_note
   = note.[0] in print_notes pressed_note else print_endline "Invalid
   input"

   (* main event loop *) let listen_for_commands () = while Atomic.get
   Metronome.is_on do let input = read_line () in if input = "stop" then
   Atomic.set Metronome.is_on false else match float_of_string_opt input
   with | None -> play_note input | Some x -> Metronome.set_bpm x done

   let metronome_commands pool () = let start = Task.async pool (fun _
   -> Metronome.start_metronome (Unix.gettimeofday () +. 1.) ()) in let
   listener = Task.async pool (fun _ -> listen_for_commands ()) in let _
   = Task.await pool start in let _ = Task.await pool listener in ()

   (* initialize *) let () = let pool = Task.setup_pool ~num_domains:4
   () in print_endline "Starting your metronome... (type 'stop' to stop
   and an integer to \ change the bpm)"; let _ = Task.run pool (fun ()
   -> metronome_commands pool ()) in (* Task.teardown_pool pool; *)
   print_endline "Metronome stopped." *)
