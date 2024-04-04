open Music

let screenWidth = 800
let screenHeight = 450
let notes = [ "C5"; "D5"; "E5"; "F5"; "G5"; "A5"; "B5"; "C6" ]

let setup () =
  let open Raylib in
  init_window screenWidth screenHeight "OCaml Keyboard";
  init_audio_device ();

  (* let music = load_sound "assets/metronome-trimmed.wav" in

     play_sound music; *)
  let metronome = Metronome.start 60. in

  let keys =
    List.mapi
      (fun i note ->
        Button.create note
          (Rectangle.create
             (100. +. (75. *. float_of_int i))
             100. 60. 300.))
      notes
  in

  set_target_fps 60;
  (metronome, keys)

let rec loop metronome keys =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.gray;
    (* draw_rectangle 0 0 20 100 Color.white; draw_rectangle 25 0 20 100
       Color.white; draw_rectangle 50 0 20 100 Color.white; *)
    draw_text "OCaml Keyboard" 10 10 20 Color.white;

    (List.iter (fun key -> key ())) keys;
    metronome ();
    end_drawing ();
    loop metronome keys

let () =
  let metronome, keys = setup () in
  loop metronome keys
