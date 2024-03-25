let notes : char list = [ 'a'; 'b'; 'c'; 'd'; 'e' ]
let pressed_notes : bool list = [ true; false; true; false; false ]

let rec print_notes pressed_notes notes =
  match (pressed_notes, notes) with
  | [], [] -> ()
  | true :: t_pressed, h_notes :: t_notes ->
      ANSITerminal.print_string
        [ ANSITerminal.green; ANSITerminal.on_black ]
        (String.make 1 h_notes);
      print_notes t_pressed t_notes
  | false :: t_pressed, h_notes :: t_notes ->
      ANSITerminal.print_string
        [ ANSITerminal.white; ANSITerminal.on_black ]
        (String.make 1 h_notes);
      print_notes t_pressed t_notes
  | _, _ -> ()

let () =
  print_endline "Welcome to Caml Music!";
  print_notes pressed_notes notes;
  print_newline ()
