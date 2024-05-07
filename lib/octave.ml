let curr_octave = ref 0

let init_decrease_button =
  let decrease_octave_key = Raylib.Key.Minus in
  (* let increase_octave_key = Raylib.Key.Equal in *)
  let x_pos_top_left = 645 in
  let y_pos_top_left = 90 in
  let width = 30 in
  let height = 30 in
  let color = Raylib.Color.lightgray in
  let text = "-" in
  Button.create_general_with_key_binding ~draw_text:true
    ~opt_color:color ~opt_text:text decrease_octave_key x_pos_top_left
    y_pos_top_left width height (fun () ->
      if !curr_octave > 1 then curr_octave := !curr_octave - 1)

let init_increase_button =
  let increase_octave_key = Raylib.Key.Equal in
  let x_pos_top_left = 745 in
  let y_pos_top_left = 90 in
  let width = 30 in
  let height = 30 in
  let color = Raylib.Color.lightgray in
  let text = "+" in
  Button.create_general_with_key_binding ~draw_text:true
    ~opt_color:color ~opt_text:text increase_octave_key x_pos_top_left
    y_pos_top_left width height (fun () ->
      if !curr_octave < 5 then curr_octave := !curr_octave + 1)

let draw_octave_text () =
  let x_pos = 678 in
  let y_pos = 95 in
  let size = 19 in
  let text = "Octave" in
  Raylib.draw_text text x_pos y_pos size Raylib.Color.gold
