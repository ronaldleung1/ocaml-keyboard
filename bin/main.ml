open Music

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
  print_newline ()


let () = Lwt_main.run (Metronome.start_metronome ())
