open Music
let screenWidth = 800
let screenHeight = 450

let load_instruments_from_csv file_path =
  let ic = open_in file_path in
  let rec read_lines acc =
    try
      let line = input_line ic in
      let instrument = String.trim line in
      if instrument <> "" then
        read_lines ((instrument, Instrument.create instrument) :: acc)
      else acc
    with End_of_file ->
      close_in ic;
      List.rev acc
  in
  read_lines []

let trim_null_chars s =
  try
    let index = String.index s '\000' in
    String.sub s 0 index
  with Not_found -> s

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
let preset_list_scroll_index = ref 0
let preset_list_active = ref (-1)
let preset_list_focus = ref 0
let prev_preset = ref (-1)
let show_save_input_box = ref false
let save_input_text = ref ""
let curr_library = ref Library.empty
let selected_playlist_index = ref 0
let scroll_playlist_index = ref 0
let focus_playlist_index = ref 0
let selected_song_index = ref 0
let scroll_song_index = ref 0
let focus_song_index = ref 0
let text_box_playlist_name = ref ""
let text_box_playlist_edit = ref false
let text_box_song_title = ref ""
let text_box_song_edit = ref false
let text_box_song_artist = ref ""
let text_box_song_artist_edit = ref false
let text_box_song_duration = ref ""
let text_box_song_duration_edit = ref false

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
         "piano" ~view_only:false !sustain_on ())
  in
  let octave_keys =
    [ Octave.init_decrease_button; Octave.init_increase_button ]
  in
  set_target_fps 60;
  (metronome, !keys, octave_keys, volume_control)

let rec library_loop () =
  try
    if Raylib.window_should_close () then Raylib.close_window ()
    else
      let open Raylib in
      begin_drawing ();
      clear_background Color.gray;
      draw_text "Library Management" 10 10 20 Color.white;

      let playlists =
        List.map Playlist.get_name (Library.get_playlists !curr_library)
      in

      let playlist_rect = Rectangle.create 15.0 105.0 150.0 330.0 in
      let song_rect = Rectangle.create 180.0 105.0 150.0 330.0 in
      draw_text "Playlists" 15 80 20 Color.gold;
      draw_text "Songs" 180 80 20 Color.gold;

      let ( list_active_playlist,
            list_focus_playlist,
            list_scroll_playlist ) =
        Raygui.list_view_ex playlist_rect playlists
          !focus_playlist_index !scroll_playlist_index
          !selected_playlist_index
      in
      scroll_playlist_index := list_scroll_playlist;
      selected_playlist_index := list_active_playlist;
      focus_playlist_index := list_focus_playlist;
      let songs =
        match !selected_playlist_index with
        | -1 -> []
        | index when index >= 0 && index < List.length playlists ->
            let playlist =
              List.nth (Library.get_playlists !curr_library) index
            in
            List.map Song.title (Playlist.get_songs playlist)
        | _ -> []
      in
      let list_active_song, list_focus_song, list_scroll_song =
        Raygui.list_view_ex song_rect songs !focus_playlist_index
          !scroll_song_index !selected_song_index
      in
      scroll_song_index := list_scroll_song;
      selected_song_index := list_active_song;
      focus_song_index := list_focus_song;

      let playlists = Library.get_playlists !curr_library in
      if
        !selected_playlist_index >= 0
        && !selected_playlist_index < List.length playlists
      then
        let playlist = List.nth playlists !selected_playlist_index in
        let songs = Playlist.get_songs playlist in
        if
          !selected_song_index >= 0
          && !selected_song_index < List.length songs
        then
          let song = List.nth songs !selected_song_index in
          let details = Song.to_string_detailed song in
          draw_text details 350 80 22 Color.yellow
        else ()
      else ();

      draw_text "Playlist Name:" 500 130 20 Color.gold;
      let () =
        text_box_playlist_name :=
          match
            Raygui.text_box
              (Rectangle.create 500.0 150.0 180.0 30.0)
              !text_box_playlist_name !text_box_playlist_edit
          with
          | vl, true ->
              text_box_playlist_edit := not !text_box_playlist_edit;
              vl
          | vl, false -> vl
      in
      draw_text "Song Title:" 500 200 20 Color.gold;
      let () =
        text_box_song_title :=
          match
            Raygui.text_box
              (Rectangle.create 500.0 220.0 180.0 30.0)
              !text_box_song_title !text_box_song_edit
          with
          | vl, true ->
              text_box_song_edit := not !text_box_song_edit;
              vl
          | vl, false -> vl
      in
      draw_text "Song Artist:" 500 260 20 Color.gold;
      let () =
        text_box_song_artist :=
          match
            Raygui.text_box
              (Rectangle.create 500.0 280.0 180.0 30.0)
              !text_box_song_artist
              !text_box_song_artist_edit
          with
          | vl, true ->
              text_box_song_artist_edit :=
                not !text_box_song_artist_edit;
              vl
          | vl, false -> vl
      in

      draw_text "Song Duration (sec):" 500 320 20 Color.gold;
      let () =
        text_box_song_duration :=
          match
            Raygui.text_box
              (Rectangle.create 500.0 340.0 180.0 30.0)
              !text_box_song_duration
              !text_box_song_duration_edit
          with
          | vl, true ->
              text_box_song_duration_edit :=
                not !text_box_song_duration_edit;
              vl
          | vl, false -> vl
      in

      let button_add_playlist_rect =
        Rectangle.create 350.0 130.0 100.0 30.0
      in
      let button_remove_playlist_rect =
        Rectangle.create 350.0 180.0 100.0 30.0
      in
      let button_add_song_rect =
        Rectangle.create 350.0 250.0 100.0 30.0
      in
      let button_remove_song_rect =
        Rectangle.create 350.0 300.0 100.0 30.0
      in

      if Raygui.button button_add_playlist_rect "Add Playlist" then
        let new_playlist = Playlist.create !text_box_playlist_name in
        Library.add_new_playlist new_playlist !curr_library
      else ();

      if Raygui.button button_remove_playlist_rect "Remove Playlist"
      then
        match !selected_playlist_index with
        | index when index >= 0 && index < List.length playlists ->
            let playlist = List.nth playlists index in
            Library.remove_playlist
              (Playlist.get_name playlist)
              !curr_library
        | _ -> ()
      else ();

      if Raygui.button button_add_song_rect "Add Song" then
        match !selected_playlist_index with
        | index when index >= 0 && index < List.length playlists -> (
            let playlist = List.nth playlists index in
            let duration_result =
              try
                Some
                  (int_of_string
                     (trim_null_chars !text_box_song_duration))
              with Failure _ -> None
            in
            match duration_result with
            | Some duration ->
                let new_song =
                  Song.create
                    (trim_null_chars !text_box_song_title)
                    (trim_null_chars !text_box_song_artist)
                    duration
                in
                Playlist.add_song playlist new_song
            | None -> ())
        | _ -> ()
      else ();

      if Raygui.button button_remove_song_rect "Remove Song" then
        match (!selected_playlist_index, !selected_song_index) with
        | playlist_index, song_index
          when playlist_index >= 0
               && playlist_index < List.length playlists
               && song_index >= 0
               && song_index < List.length songs ->
            let playlist = List.nth playlists playlist_index in
            let song = List.nth songs song_index in
            Playlist.remove_song playlist song
        | _ -> ()
      else ();

      end_drawing ();
      if
        not
          (Raygui.button
             (Rectangle.create 330.0 42.0 125.0 30.0)
             "Exit Library Menu")
      then library_loop () (* Continue the inner loop *)
      else ()
  with _ -> ()

let rec loop
    metronome
    _
    octave_keys
    (volume_control : unit -> float ref) =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.darkgray;
    let presets = Presets.load_array_from_file "presets.txt" in

    if !show_save_input_box then Raygui.lock ();

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

    draw_rectangle_rec
      (Rectangle.create 0. 0. (float_of_int screenWidth) 40.)
      Color.black;

    draw_text "OCaml Keyboard" 10 10 20 Color.white;
    Octave.draw_octave_text ();

    let library_button_rect = Rectangle.create 330.0 42.0 125.0 30.0 in
    let library_button_text = "Library Menu" in
    if Raygui.button library_button_rect library_button_text then
      library_loop ();

    let sustain_button_rect = Rectangle.create 490. 10. 100. 20. in
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

    draw_text "Search below" 175 42 18 Color.lightgray;
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
    let rect = Rectangle.create 175.0 62.0 125.0 30.0 in
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

    draw_text
      ("Instrument: " ^ !current_instrument)
      200 10 18 Color.gold;
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
    let rect = Rectangle.create 625.0 62.0 150.0 20.0 in
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

    let presets_list = Array.to_list !presets in
    let preset_names = List.map fst presets_list in
    draw_text "Presets" 175 95 15 Color.lightgray;
    let list_view_rect = Rectangle.create 175. 110. 125. 100. in
    let selected_preset, focus_preset_index, selected_preset_index =
      Raygui.list_view_ex list_view_rect preset_names !preset_list_focus
        !preset_list_scroll_index
        !preset_list_active
    in
    preset_list_active := selected_preset;
    preset_list_scroll_index := selected_preset_index;
    preset_list_focus := focus_preset_index;
    let () =
      if !preset_list_active == -1 || List.length presets_list = 0 then (
        current_instrument := !previous_instrument;
        prev_preset := -1)
      else if
        !preset_list_active < List.length presets_list
        && !prev_preset <> !preset_list_active
      then (
        let bpm, vol, instr =
          snd (List.nth presets_list !preset_list_active)
        in
        current_instrument := instr;
        previous_instrument := instr;
        text_box_text := !current_instrument;
        prev_preset := !preset_list_active;
        (list_view_scroll_index :=
           let instr_idx =
             match
               List.find_index
                 (fun name -> name = instr)
                 valid_instrument_names
             with
             | Some x -> x
             | None -> failwith "Cant find instrument"
           in
           if List.length valid_instrument_names - instr_idx <= 8 then
             instr_idx - 8
           else instr_idx);

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
        loop (Metronome.start bpm) keys octave_keys (Volume.start vol))
      else ()
    in

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
    else
      (* Check if save button is pressed *)
      let rect = Rectangle.create 175.0 212.0 125.0 30.0 in
      show_save_input_box :=
        if Raygui.button rect "Save Preset" then 
          let () = save_input_text := "" in
          true
        else !show_save_input_box;
      if not !show_save_input_box then Raygui.unlock ();

      let keys =
        if !show_save_input_box then (
          (* Handle save popup interaction *)
          let text_input_text, show_text_input_box =
            if !show_save_input_box then (
              draw_rectangle 0 0 (get_screen_width ())
                (get_screen_height ())
                (fade Color.raywhite 0.8);
              Raygui.unlock ();
              let text_input_text, res =
                Raygui.text_input_box
                  (Rectangle.create
                     ((float_of_int (get_screen_width ()) /. 2.0)
                     -. 120.0)
                     ((float_of_int (get_screen_height ()) /. 2.0)
                     -. 60.0)
                     240.0 140.0)
                  "Save this preset!" "Enter a name below" "Ok;Cancel"
                  !save_input_text
              in
              if res = 1 then (
                let () = text_box_edit_mode := false in
                let current_bpm = current_bpm in
                let current_volume = !volume in
                let preset_data =
                  ( trim_null_chars !save_input_text,
                    (current_bpm, current_volume, !current_instrument)
                  )
                in
                let preset_string = Presets.data_to_string preset_data in
                Presets.print_string_to_file "presets.txt" preset_string;
                (text_input_text, false))
              else if res = 0 || res = 2 then (
                text_box_edit_mode := false;
                (text_input_text, false))
              else (
                text_box_edit_mode := true;
                (text_input_text, !show_save_input_box)))
            else (!save_input_text, !show_save_input_box)
          in
          save_input_text := text_input_text;
          show_save_input_box := show_text_input_box;

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
              !sustain_on)
        else keys
      in
      (* prev_text_box_edit_mode := !text_box_edit_mode; *)

      end_drawing ();
      loop metronome keys octave_keys volume_control

let () =
  let metronome, keys, octave_keys, volume_control = setup () in
  loop metronome keys octave_keys volume_control
