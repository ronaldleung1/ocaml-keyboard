open Music
open Domainslib
let notes = [ 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G' ]

let print_notes pressed_note =
  List.iter
    (fun note ->
      if Char.equal note pressed_note then
        ANSITerminal.print_string
          [ ANSITerminal.green; ANSITerminal.on_black ]
          (String.make 1 note)
      else
        ANSITerminal.print_string
          [ ANSITerminal.white; ANSITerminal.on_black ]
          (String.make 1 note))
    notes

let () =
  print_endline "Welcome to Caml Music!";
  print_endline "Enter a note (A-G):";
  let input = read_line () in
  if String.length input > 0 then
    let pressed_note = input.[0] in
    print_notes pressed_note
  else print_endline "No note entered";
  print_newline ();
  print_string "Enter the beats per minute for your metronome: ";
  let bpm = read_line () in
  Metronome.set_bpm (float_of_int ((int_of_string) bpm));
  print_newline ()

let listen_for_commands () =
  while Atomic.get Metronome.is_on do
    let input = read_line () in
    if input = "stop" then Atomic.set Metronome.is_on false
    else Metronome.set_bpm (float_of_string input)
  done

let metronome_commands pool () = 
  let start = Task.async pool (fun _ -> Metronome.start_metronome (Unix.gettimeofday() +. 1.) ()) in
  let _ = Task.async pool (fun _ -> listen_for_commands ()) in
  let _ = Task.await pool start in ()

let () = 
  let pool = Task.setup_pool ~num_domains:4 () in
  print_endline "Starting your metronome... (type 'stop' to stop and an integer to set the beats per minute)";
  let _ = Task.run pool (fun () -> metronome_commands pool ()) in
  Task.teardown_pool pool;
  print_endline "Metronome stopped.";


