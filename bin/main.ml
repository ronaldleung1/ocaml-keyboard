open Music

let screenWidth = 800
let screenHeight = 450
let argv : string list = Array.to_list Sys.argv

let setup () =
  let open Raylib in
  init_window screenWidth screenHeight "OCaml Keyboard";
  init_audio_device ();

  (* let music = load_sound "assets/metronome-trimmed.wav" in

     play_sound music; *)
  let metronome = Metronome.start 60. in

  let keys = Keyboard.init_keyboard 5 in

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

let playlist () =
  let song1 = Song.create "Song 1" "Artist 1" 240 in
  let song2 = Song.create "Song 2" "Artist 2" 300 in
  let song3 = Song.create "Song 3" "Artist 3" 180 in

  let my_playlist = Playlist.create "My Favorite Songs" in

  Playlist.add_song my_playlist song1;
  Playlist.add_song my_playlist song2;
  Playlist.add_song my_playlist song3;

  let song1_in_playlist = Playlist.contains my_playlist "Song 2" in
  Printf.printf "Is 'Song Two' in the playlist? %B" song1_in_playlist;
  print_newline ();

  Playlist.remove_song my_playlist "Song 3";

  let song3_in_playlist = Playlist.contains my_playlist "Song 3" in
  Printf.printf "Is 'Song Three' in the playlist after removal? %B\n"
    song3_in_playlist

let () =
  if List.mem "playlist" argv then playlist ()
  else begin
    let metronome, keys = setup () in
    loop metronome keys
  end
