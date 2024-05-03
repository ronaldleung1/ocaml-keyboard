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

let white_key_codes =
  let open Raylib.Key in
  [
    [ Z ];
    [ X ];
    [ C ];
    [ V ];
    [ B ];
    [ N ];
    [ M ];
    [ Q; Comma ];
    [ W; Period ];
    [ E; Slash ];
    [ R ];
    [ T ];
    [ Y ];
    [ U ];
    [ I ];
  ]

let white_key_code_strings =
  [
    [ "Z" ];
    [ "X" ];
    [ "C" ];
    [ "V" ];
    [ "B" ];
    [ "N" ];
    [ "M" ];
    [ "Q" ];
    [ "W" ];
    [ "E" ];
    [ "R" ];
    [ "T" ];
    [ "Y" ];
    [ "U" ];
    [ "I" ];
  ]

let black_key_codes =
  let open Raylib.Key in
  [
    [ S ];
    [ D ];
    [ G ];
    [ H ];
    [ J ];
    [ Two; L ];
    [ Three; Semicolon ];
    [ Five ];
    [ Six ];
    [ Seven ];
  ]

(* let curr_octave = ref 0 *)

let black_key_code_strings =
  [
    [ "S" ];
    [ "D" ];
    [ "G" ];
    [ "H" ];
    [ "J" ];
    [ "2" ];
    [ "3" ];
    [ "5" ];
    [ "6" ];
    [ "7" ];
  ]

(* TODO test this *)
(* combine two lists l1 and l2 into an association list *)
let rec combine_lists l1 l2 =
  match (l1, l2) with
  | [], [] -> []
  | [], _ | _, [] -> failwith "Lists have different lengths"
  | x :: xs, y :: ys -> (x, y) :: combine_lists xs ys

(* map a function f over two lists l1 and l2, with the index of the
   element as the first argument to f *)
let map2i f l1 l2 =
  List.map2
    (fun i (x, y) -> f i x y)
    (List.init (List.length l1) Fun.id)
    (combine_lists l1 l2)

let init_keyboard
    (init_octave : int)
    rect
    instrument
    view_only
    sustain_on =
  Octave.curr_octave := init_octave;
  (* get keys of a 2-octave keyboard, from C[k] to C[k+2], where [k] is
     the octave *)
  let curr_notes =
    List.filter
      (fun note ->
        let octave_ascii = !Octave.curr_octave + 48 in
        String.contains note (char_of_int octave_ascii)
        || String.contains note (char_of_int octave_ascii)
        || String.contains note (char_of_int (octave_ascii + 1))
        || String.contains note 'C'
           && String.contains note (char_of_int (octave_ascii + 2)))
      notes
  in
  let keyboard_width = int_of_float (Raylib.Rectangle.width rect) in

  let num_octaves = 2 in

  (* 7 white keys, 5 black keys *)
  let white_keys =
    let num_segments = (7 * num_octaves) + 1 in
    (* 15 segments, 15 white keys *)
    let key_width = keyboard_width / num_segments in
    let white_notes =
      List.filter
        (fun note -> not (String.contains note 'b'))
        curr_notes
    in
    map2i
      (fun i note key_code ->
        let x =
          (i * key_width) + int_of_float (Raylib.Rectangle.x rect)
        in
        let y = int_of_float (Raylib.Rectangle.y rect) in
        let width = key_width in
        let height = int_of_float (Raylib.Rectangle.height rect) in
        let color = Raylib.Color.white in
        let key_string = List.nth white_key_code_strings i in
        if view_only then
          Button.create ~draw_text:true ~opt_color:color ~view_only:true
            note key_code key_string
            (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
               (float_of_int width) (float_of_int height))
            instrument
        else
          Button.create ~draw_text:true ~opt_color:color ~sustain_on
            note key_code key_string
            (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
               (float_of_int width) (float_of_int height))
            instrument)
      white_notes white_key_codes
  in

  let black_keys =
    (* 25 black key segments, only 10 black keys though *)
    let num_segments = 12 * num_octaves in

    (* 15 segments, 15 white keys *)
    let num_white_segments = (7 * num_octaves) + 1 in
    (* account for gap between keys of 1 *)
    let white_key_width = (keyboard_width / num_white_segments) + 1 in

    let key_width = (keyboard_width - white_key_width) / num_segments in

    let black_notes =
      List.filter (fun note -> String.contains note 'b') curr_notes
    in
    (* indices of Db, Eb, etc. in the list of notes *)
    let black_indices = [ 1; 3; 6; 8; 10 ] in
    let black_keys =
      map2i
        (fun i note key_code ->
          let x =
            (List.nth black_indices (i mod 5) + (i / 5 * 12))
            * key_width
          in
          let y = int_of_float (Raylib.Rectangle.y rect) in
          let width = key_width in
          let height =
            int_of_float (Raylib.Rectangle.height rect *. 2. /. 3.)
          in
          let color = Raylib.Color.black in
          let key_string = List.nth black_key_code_strings i in
          if view_only then
            Button.create ~draw_text:true ~opt_color:color
              ~view_only:true note key_code key_string
              (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
                 (float_of_int width) (float_of_int height))
              instrument
          else
            Button.create ~draw_text:true ~opt_color:color ~sustain_on
              note key_code key_string
              (Raylib.Rectangle.create (float_of_int x) (float_of_int y)
                 (float_of_int width) (float_of_int height))
              instrument)
        black_notes black_key_codes
    in
    black_keys
  in
  white_keys @ black_keys

(* last_octave and keyboard is needed to make sure that refresh only
   recreates the keyboard when octave is different. Otherwise it would
   redraw in every loop, canceling the block animation *)
let last_octave = ref (-1)
let keyboard = ref []

let refresh
    rect
    instrument
    changed_instrument
    changed_view
    view_only
    changed_sustain
    sustain_on =
  if
    !Octave.curr_octave <> !last_octave
    || changed_instrument || changed_view || changed_sustain
  then begin
    keyboard :=
      init_keyboard !Octave.curr_octave rect instrument view_only
        sustain_on;
    last_octave := !Octave.curr_octave
  end;
  !keyboard
