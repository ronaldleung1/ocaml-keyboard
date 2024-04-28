open Music
open Instrument 

let screenWidth = 800
let screenHeight = 450
let argv : string list = Array.to_list Sys.argv

(*user can pick instrument*)
let instruments = [("Guitar", create_instrument "Guitar"); 
("Brass", create_instrument "Brass"); 
("Drumkit", create_instrument "Drumkit"); 
("Yodele", create_instrument "Yodele")] 
let instrument_names = String.concat ";" (List.map fst instruments)
let instrument_index = ref 0
let dropdown_active = ref false

let setup () =
  let open Raylib in
  init_window screenWidth screenHeight "OCaml Keyboard";
  init_audio_device ();

  let metronome = Metronome.start 60. in
  let volume_control = Volume.start 5. in

  (* Initialize volume control with default volume level *)
  let keys =
      ref (Keyboard.init_keyboard 5
        (Rectangle.create 0.
          (float_of_int (Raylib.get_screen_height ()) -. 100.)
          (float_of_int (Raylib.get_screen_width ()))
          100.))
  in
  set_target_fps 60;
  (metronome, !keys, volume_control)

let rec loop metronome keys volume_control =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.gray;
    draw_text "OCaml Keyboard" 10 10 20 Color.white;

    (List.iter (fun key -> key ())) keys;
    metronome ();
    volume_control ();
    (* Adjust volume as needed *)
    Raygui.(
      set_style (DropdownBox `Text_alignment) TextAlignment.(to_int Left));
    let rect = Rectangle.create 10. 40. 120. 30. in
    let () =
      match
        Raygui.dropdown_box rect instrument_names !instrument_index
          !dropdown_active
      with
      | vl, true -> let () = instrument_index := vl; dropdown_active := not !dropdown_active in ()
      | vl, false -> let () = instrument_index := vl; dropdown_active := !dropdown_active in ()
    in
    let selected_instrument = List.nth instruments !instrument_index |> snd in
    
    end_drawing ();
    loop metronome keys volume_control

let print_blue text =
  print_endline
    (ANSITerminal.sprintf
       [ ANSITerminal.Foreground ANSITerminal.Blue ]
       "%s" text)

let print_cyan text =
  print_endline
    (ANSITerminal.sprintf
       [ ANSITerminal.Foreground ANSITerminal.Cyan ]
       "%s" text)

let rec playlist_menu my_playlist =
  print_cyan "What do you want to do with the playlist?";
  print_cyan "1. View playlist";
  print_cyan "2. Add a song to a playlist";
  print_cyan "3. Remove a song from a playlist";
  print_cyan "4. Check if a playlist contains a song";
  print_cyan "5. View total duration a playlist";
  print_cyan "Type 'quit' to return to playlist manager";
  let choice = read_line () in
  match choice with
  | "quit" -> print_cyan "Returning to playlist manager."
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

let rec library_menu library =
  print_blue "Select an option:";
  print_blue "1. View all playlists";
  print_blue "2. Add a new empty playlist";
  print_blue "3. Remove a playlist";
  print_blue "4. Manage a specific playlist";
  print_blue "Type 'quit' to exit.";
  let choice = read_line () in
  match choice with
  | "quit" ->
      print_blue "Exiting playlist manager.";
      exit 0
  | "1" ->
      print_endline "Viewing library...";
      print_endline (Library.display library);
      library_menu library
  | "2" ->
      print_endline "What is the name of the playlist?";
      let name = read_line () in
      let playlist = Playlist.create name in
      Library.add_new_playlist playlist library;
      print_endline "Added new playlist to library.";
      library_menu library
  | "3" ->
      print_endline "Enter the name of the playlist to remove:";
      let name = read_line () in
      Library.remove_playlist name library;
      print_endline "Removed playlist from library.";
      library_menu library
  | "4" ->
      print_endline "Enter the name of the playlist to manage:";
      let name = read_line () in
      (match Library.find_playlist name library with
      | Some playlist -> playlist_menu playlist
      | None -> print_endline "Playlist not found.");
      library_menu library
  | _ -> library_menu library

let () =
  if List.mem "playlist" argv then library_menu Library.empty
  else begin
    let metronome, keys, volume_control  = setup () in
    loop metronome keys volume_control
  end

