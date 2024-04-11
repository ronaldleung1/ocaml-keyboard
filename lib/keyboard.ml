let notes =
  [
    "A0";
    "Bb0";
    "B0";
    "C1";
    "Db1";
    "D1";
    "Eb1";
    "E1";
    "F1";
    "Gb1";
    "G1";
    "Ab1";
    "A1";
    "Bb1";
    "B1";
    "C2";
    "Db2";
    "D2";
    "Eb2";
    "E2";
    "F2";
    "Gb2";
    "G2";
    "Ab2";
    "A2";
    "Bb2";
    "B2";
    "C3";
    "Db3";
    "D3";
    "Eb3";
    "E3";
    "F3";
    "Gb3";
    "G3";
    "Ab3";
    "A3";
    "Bb3";
    "B3";
    "C4";
    "Db4";
    "D4";
    "Eb4";
    "E4";
    "F4";
    "Gb4";
    "G4";
    "Ab4";
    "A4";
    "Bb4";
    "B4";
    "C5";
    "Db5";
    "D5";
    "Eb5";
    "E5";
    "F5";
    "Gb5";
    "G5";
    "Ab5";
    "A5";
    "Bb5";
    "B5";
    "C6";
    "Db6";
    "D6";
    "Eb6";
    "E6";
    "F6";
    "Gb6";
    "G6";
    "Ab6";
    "A6";
    "Bb6";
    "B6";
    "C7";
    "Db7";
    "D7";
    "Eb7";
    "E7";
    "F7";
    "Gb7";
    "G7";
  ]

let init_keyboard init_octave =
  let curr_octave = ref init_octave in
  (* get keys of a 2-octave keyboard, from C[k] to C[k+2], where [k] is
     the octave *)
  let curr_notes =
    List.filter
      (fun note ->
        let octave_ascii = !curr_octave + 48 in
        String.contains note (char_of_int octave_ascii)
        || String.contains note (char_of_int octave_ascii)
        || String.contains note (char_of_int (octave_ascii + 1))
        || String.contains note 'C'
           && String.contains note (char_of_int (octave_ascii + 2)))
      notes
  in
  let screen_length = Raylib.get_screen_width () in

  let num_octaves = 2 in
  let num_keys_octave = 15 in

  (* 7 white keys, 5 black keys *)
  let white_keys =
    let num_segments = (7 * num_octaves) + 1 in
    (* 15 segments, 15 white keys *)
    let key_width = screen_length / num_segments in
    let white_notes =
      List.filter
        (fun note -> not (String.contains note 'b'))
        curr_notes
    in
    List.mapi
      (fun i note ->
        let x = i * key_width in
        let y = 100 in
        let width = key_width in
        let height = 300 in
        let color = Raylib.Color.white in
        Button.create ~draw_text:true ~opt_color:color note
          (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
             (float_of_int width) (float_of_int height)))
      white_notes
  in

  let black_keys =
    (* 25 black key segments, only 10 black keys though *)
    let num_segments = 12 * num_octaves in

    (* 15 segments, 15 white keys *)
    let num_white_segments = (7 * num_octaves) + 1 in
    (* account for gap between keys of 1 *)
    let white_key_width = (screen_length / num_white_segments) + 1 in

    let key_width = (screen_length - white_key_width) / num_segments in

    let black_notes =
      List.filter (fun note -> String.contains note 'b') curr_notes
    in
    (* indices of Db, Eb, etc. in the list of notes *)
    let black_indices = [ 1; 3; 6; 8; 10 ] in
    let black_keys =
      List.mapi
        (fun i note ->
          let x =
            (List.nth black_indices (i mod 5) + (i / 5 * 12))
            * key_width
          in
          let y = 100 in
          let width = key_width in
          let height = 200 in
          let color = Raylib.Color.black in
          Button.create ~draw_text:true ~opt_color:color note
            (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
               (float_of_int width) (float_of_int height)))
        black_notes
    in
    black_keys
  in
  white_keys @ black_keys
