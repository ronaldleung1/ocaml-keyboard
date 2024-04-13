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

let rec playlist_menu my_playlist =
  print_endline "What do you want to do with the playlist?";
  print_endline "1. View playlist";
  print_endline "2. Add a song to a playlist";
  print_endline "3. Remove a song from a playlist";
  print_endline "4. Check if a playlist contains a song";
  print_endline "5. View total duration a playlist";
  print_endline "Type 'quit' to exit.";
  let choice = read_line () in
  match choice with
  | "quit" ->
      print_endline "Exiting playlist manager.";
      exit 0
  | "1" ->
      print_endline "Viewing playlist...";
      print_endline (Playlist.display my_playlist);
      playlist_menu my_playlist
  | "2" ->
      print_endline "What is the title of the song?";
      let title = read_line () in
      print_endline "Who is the artist of the song?";
      let artist = read_line () in
      print_endline "What is the duration of the song?";
      let duration = read_line () in
      let song = Song.create title artist (int_of_string duration) in
      Playlist.add_song my_playlist song;
      print_endline "Added song to playlist.";
      playlist_menu my_playlist
  | "3" ->
      print_endline "What is the title of the song?";
      let title = read_line () in
      Playlist.remove_song my_playlist title;
      playlist_menu my_playlist
  | "4" ->
      print_endline "What is the title of the song?";
      let title = read_line () in
      print_endline
        (string_of_bool (Playlist.contains my_playlist title));
      playlist_menu my_playlist
  | "5" -> print_endline (Playlist.total_duration my_playlist)
  | _ -> playlist_menu my_playlist

let () =
  let song1 = Song.create "Song 1" "Artist 1" 240 in
  let song2 = Song.create "Song 2" "Artist 2" 300 in
  let song3 = Song.create "Song 3" "Artist 3" 180 in

  let my_playlist = Playlist.create "My Favorite Songs" in

  Playlist.add_song my_playlist song1;
  Playlist.add_song my_playlist song2;
  Playlist.add_song my_playlist song3;

  if List.mem "playlist" argv then playlist_menu my_playlist
  else begin
    let metronome, keys = setup () in
    loop metronome keys
  end
