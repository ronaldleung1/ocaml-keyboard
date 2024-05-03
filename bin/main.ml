open Music
open Instrument

let screenWidth = 800
let screenHeight = 450
let argv : string list = Array.to_list Sys.argv

let load_instruments_from_csv file_path =
  let ic = open_in file_path in
  let rec read_lines acc =
    try
      let line = input_line ic in
      let instrument = String.trim line in
      if instrument <> "" then
        read_lines ((instrument, create_instrument instrument) :: acc)
      else acc
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  read_lines []

let instruments = load_instruments_from_csv "assets/instruments.csv"
let valid_instrument_names = List.map fst instruments
let list_view_scroll_index = ref 0
let list_view_active = ref 0
let list_view_ex_focus = ref 0
let previous_instrument = ref "piano"
let current_instrument = ref "piano"
let volume_slider = ref 5.0
let text_box_text = ref ""
let text_box_edit_mode = ref false
let prev_text_box_edit_mode = ref false
let last_filter = ref ""
let sustain_on = ref false

(* Function to save the contents of an array to a file *)
let save_array_to_file filename arr =
  let oc = open_out filename in
  Array.iter (fun x -> output_string oc (x ^ "\n")) arr;
  close_out oc

(*prints string to filename for saving saved to saved.txt after
  converting it to string*)
let print_string_to_file filename str =
  let out_channel = open_out filename in
  output_string out_channel str;
  close_out out_channel

(* Function to load the contents of an array from a file *)
let load_array_from_file filename =
  try
    let ic = open_in filename in
    let rec read_lines acc =
      try
        let line = input_line ic in
        let parts = String.split_on_char ',' line in
        match parts with
        | x :: y :: z :: _ ->
            let float_x = float_of_string x in
            let float_y = float_of_string y in
            let str_z = z in
            (* let () = print_endline (string_of_float float_x) in let
               () = print_endline (string_of_float float_y) in let () =
               print_endline str_z in *)
            read_lines ((float_x, float_y, str_z) :: acc)
        | _ -> read_lines acc (* Ignore malformed lines *)
      with End_of_file -> List.rev acc
    in
    let lines = read_lines [] in
    close_in ic;
    ref (Array.of_list lines)
  with Sys_error _ ->
    ref [||] (* Default value if the file doesn't exist *)

(*converts tuple to string, mainly to allow program to easily convert
  string in file back to original array*)
let tuple_to_string (x, y, z) =
  string_of_float x ^ "," ^ string_of_float y ^ "," ^ z ^ "\n"

(*converts array to string, for storing saved in file *)
let array_to_string arr =
  let str = ref "" in
  for i = 0 to Array.length arr - 1 do
    str := !str ^ tuple_to_string arr.(i)
  done;
  !str

(*converting string back to tuples*)
let string_to_tuple str =
  let len = String.length str in
  let x_start = 1 in
  let y_start = String.index_from str x_start ',' + 1 in
  let z_end = len - 1 in
  let x =
    float_of_string (String.sub str x_start (y_start - x_start - 1))
  in
  let y =
    float_of_string (String.sub str y_start (z_end - y_start - 1))
  in
  let z = String.sub str (y_start + 1) (z_end - y_start - 1) in
  (x, y, z)

(*converting string produced by array_to_string back to the original
  array*)
let string_to_array str =
  let rec parse_string str idx len acc =
    if idx >= len then acc
    else
      let next_tuple_end = String.index_from str idx ')' in
      let tuple_str = String.sub str idx (next_tuple_end - idx + 1) in
      let tuple = string_to_tuple tuple_str in
      parse_string str (next_tuple_end + 1) len (tuple :: acc)
  in
  let len = String.length str in
  let tuples = parse_string str 0 len [] in
  ref (Array.of_list (List.rev tuples))

let saved : (float * float * string) array ref =
  load_array_from_file "saved.txt"
(* ref [|(60., 10., "piano"); (70., 10., "gunshot")|] *)

let () = print_string_to_file "saved.txt" (array_to_string !saved)

let setup () =
  let open Raylib in
  set_config_flags [ Window_resizable ];
  init_window screenWidth screenHeight "OCaml Keyboard";
  init_audio_device ();

  let metronome = Metronome.start 60. in
  let volume_control = Volume.start 10. in

  (* Initialize volume control with default volume level *)
  let keys =
    ref
      (Keyboard.init_keyboard 5
         (Rectangle.create 0.
            (float_of_int (Raylib.get_screen_height ()) -. 100.)
            (float_of_int (Raylib.get_screen_width ()))
            100.)
         "piano" false (!sustain_on))
  in
  let octave_keys =
    [ Octave.init_decrease_button; Octave.init_increase_button ]
  in
  set_target_fps 60;
  (metronome, !keys, octave_keys, volume_control)

let rec loop
    metronome
    keys
    octave_keys
    (volume_control : unit -> float ref) =
  if Raylib.window_should_close () then
    (* let () = print_string (!current_instrument) in *)
    (* let () = print_string_to_file "saved.txt" (tuple_to_string *)
       (* (current_bpm, !volume_slider, !current_instrument)) in *)
    Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.darkgray;
    draw_text "OCaml Keyboard" 10 10 20 Color.white;

    let sustain_button_rect = Rectangle.create 175.0 100.0 125.0 30.0 in
    let sustain_button_text =
      if !sustain_on then "Sustain: ON" else "Sustain: OFF"
    in
    let toggle_sustain () = sustain_on := not !sustain_on in
    let _ =
      if Raygui.button sustain_button_rect sustain_button_text then (
        toggle_sustain ();
        Keyboard.refresh
          (Rectangle.create 0.
             (float_of_int (Raylib.get_screen_height ()) -. 100.)
             (float_of_int (Raylib.get_screen_width ()))
             100.)
          !current_instrument true false !text_box_edit_mode true
          !sustain_on)
      else keys
    in

    draw_text "Search below" 175 40 18 Color.lightgray;
    Raygui.(
      set_style (TextBox `Text_alignment) TextAlignment.(to_int Left));
    Raygui.(
      set_style (TextBox `Border_color_normal)
        (Raylib.color_to_int Color.black));
    Raygui.(
      set_style (TextBox `Text_color_normal)
        (Raylib.color_to_int Color.white));
    Raygui.(
      set_style (TextBox `Text_color_focused)
        (Raylib.color_to_int Color.white));
    Raygui.(
      set_style (TextBox `Text_color_pressed)
        (Raylib.color_to_int Color.red));
    let rect = Rectangle.create 175.0 60.0 125.0 30.0 in
    let () =
      text_box_text :=
        match
          Raygui.text_box rect !text_box_text !text_box_edit_mode
        with
        | vl, true ->
            text_box_edit_mode := not !text_box_edit_mode;
            vl
        | vl, false -> vl
    in
    if !text_box_edit_mode then last_filter := !text_box_text;

    let trim_null_chars s =
      try
        let index = String.index s '\000' in
        String.sub s 0 index
      with Not_found -> s
    in
    (* Use the function to clean text_box_text before comparison or
       other operations *)
    let cleaned_text_box_text = trim_null_chars !text_box_text in
    if not !text_box_edit_mode then begin
      if List.mem cleaned_text_box_text valid_instrument_names then begin
        current_instrument := cleaned_text_box_text;
        last_filter := "";
        let instrument_idx =
          match
            List.find_index
              (fun name -> name = cleaned_text_box_text)
              valid_instrument_names
          with
          | Some x -> x
          | None -> failwith "Instrument not found"
        in
        list_view_active := instrument_idx;
        if !previous_instrument <> !current_instrument then begin
          previous_instrument := !current_instrument;
          if List.length valid_instrument_names - instrument_idx <= 8
          then list_view_scroll_index := instrument_idx - 8
          else list_view_scroll_index := instrument_idx
        end
      end
    end;
    let keys =
      if !prev_text_box_edit_mode <> !text_box_edit_mode then
        Keyboard.refresh
          (Rectangle.create 0.
             (float_of_int (Raylib.get_screen_height ()) -. 100.)
             (float_of_int (Raylib.get_screen_width ()))
             100.)
          !current_instrument false true !text_box_edit_mode false
          !sustain_on
      else
        Keyboard.refresh
          (Rectangle.create 0.
             (float_of_int (Raylib.get_screen_height ()) -. 100.)
             (float_of_int (Raylib.get_screen_width ()))
             100.)
          !current_instrument false false !text_box_edit_mode false
          !sustain_on
    in
    prev_text_box_edit_mode := !text_box_edit_mode;

    (List.iter (fun key -> key ())) keys;
    (List.iter (fun key -> key ())) octave_keys;

    draw_text
      ("Current Instrument: " ^ !current_instrument)
      275 12 18 Color.gold;
    let current_bpm = metronome () in
    let volume = volume_control () in
    volume_slider := !volume;

    (* Adjust volume as needed *)
    Raygui.(
      set_style (Slider `Text_color_normal)
        (Raylib.color_to_int Raylib.Color.gold));
    Raygui.(
      set_style (Slider `Border_color_normal)
        (Raylib.color_to_int Color.black));
    let rect = Rectangle.create 625.0 50.0 150.0 20.0 in
    let volume_slider_val =
      Raygui.slider rect "VOLUME"
        (Printf.sprintf "%1.1f" !volume_slider)
        !volume_slider ~min:0.0 ~max:10.0
    in
    volume_slider := volume_slider_val;
    let () = set_master_volume (!volume_slider /. 10.) in
    let volume_control = Volume.start !volume_slider in

    let filtered_instrument_list =
      if !text_box_edit_mode then
        List.filter
          (fun name ->
            String.starts_with
              ~prefix:(trim_null_chars !text_box_text)
              name)
          valid_instrument_names
      else
        List.filter
          (fun name ->
            String.starts_with
              ~prefix:(trim_null_chars !last_filter)
              name)
          valid_instrument_names
    in

    Raygui.(
      set_style (ListView `Border_color_normal)
        (Raylib.color_to_int Color.black));
    Raygui.(
      set_style (ListView `Text_color_normal)
        (Raylib.color_to_int Color.black));
    Raygui.(
      set_style (ListView `Text_color_focused)
        (Raylib.color_to_int Color.red));
    Raygui.(
      set_style (ListView `Text_color_pressed)
        (Raylib.color_to_int Color.darkgreen));
    let rect = Rectangle.create 10. 40. 150. 300. in
    let new_list_view_active, new_focus, new_list_view_scroll_index =
      Raygui.list_view_ex rect filtered_instrument_list
        !list_view_ex_focus !list_view_scroll_index !list_view_active
    in
    list_view_active := new_list_view_active;
    list_view_scroll_index := new_list_view_scroll_index;
    list_view_ex_focus := new_focus;
    if !list_view_active == -1 then list_view_active := 0;
    let selected_instrument =
      if List.length filtered_instrument_list = 0 then
        !current_instrument
      else if !list_view_active < List.length filtered_instrument_list
      then List.nth filtered_instrument_list !list_view_active
      else !current_instrument
      (* Fallback to the current instrument if the index is out of
         bounds *)
    in

    if
      selected_instrument <> !current_instrument
      && not !text_box_edit_mode
    then begin
      previous_instrument := selected_instrument;
      current_instrument := selected_instrument;
      text_box_text := !current_instrument;

      list_view_scroll_index :=
        if !last_filter <> "" then
          let instr_idx =
            match
              List.find_index
                (fun name -> name = selected_instrument)
                valid_instrument_names
            with
            | Some x -> x
            | None -> failwith "Cant find instrument"
          in
          if List.length valid_instrument_names - instr_idx <= 8 then
            instr_idx - 8
          else instr_idx
        else !list_view_scroll_index;

      last_filter := "";

      let keys =
        Keyboard.refresh
          (Rectangle.create 0.
             (float_of_int (Raylib.get_screen_height ()) -. 100.)
             (float_of_int (Raylib.get_screen_width ()))
             100.)
          !current_instrument true false !text_box_edit_mode false
          !sustain_on
      in
      end_drawing ();
      loop metronome keys octave_keys volume_control
    end
    else end_drawing ();
    loop metronome keys octave_keys volume_control

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
  print_cyan "Type ' quit ' to return to playlist manager";
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
  print_blue "Type ' quit ' to exit.";
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
    let metronome, keys, octave_keys, volume_control = setup () in
    loop metronome keys octave_keys volume_control
  end
