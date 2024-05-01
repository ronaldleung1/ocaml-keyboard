let curr_octave = ref 0

let init_decrease_button =
  let decrease_octave_key = Raylib.Key.Minus in
  (* let increase_octave_key = Raylib.Key.Equal in *)
  let x_pos_top_left = 600 in
  let y_pos_top_left = 100 in
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
  let x_pos_top_left = 700 in
  let y_pos_top_left = 100 in
  let width = 30 in
  let height = 30 in
  let color = Raylib.Color.lightgray in
  let text = "+" in
  Button.create_general_with_key_binding ~draw_text:true
    ~opt_color:color ~opt_text:text increase_octave_key x_pos_top_left
    y_pos_top_left width height (fun () ->
      if !curr_octave < 5 then curr_octave := !curr_octave + 1)
