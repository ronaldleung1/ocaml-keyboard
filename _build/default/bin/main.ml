(* let notes : char list = [ 'a'; 'b'; 'c'; 'd'; 'e' ] let pressed_notes
   : bool list = [ true; false; true; false; false ]

   let rec print_notes pressed_notes notes = match (pressed_notes,
   notes) with | [], [] -> () | true :: t_pressed, h_notes :: t_notes ->
   ANSITerminal.print_string [ ANSITerminal.green; ANSITerminal.on_black
   ] (String.make 1 h_notes); print_notes t_pressed t_notes | false ::
   t_pressed, h_notes :: t_notes -> ANSITerminal.print_string [
   ANSITerminal.white; ANSITerminal.on_black ] (String.make 1 h_notes);
   print_notes t_pressed t_notes | _, _ -> ()

   let () = print_endline "Welcome to Caml Music!"; print_notes
   pressed_notes notes; print_newline () *)

let notes = [ 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'H' ]

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
  (* Assuming the user enters a single character, take the first one *)
  if String.length input > 0 then
    let pressed_note = input.[0] in
    print_notes pressed_note
  else print_endline "No note entered";
  print_newline ()
