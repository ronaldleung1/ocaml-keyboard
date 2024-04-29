open Music
open Instrument

let screenWidth = 800
let screenHeight = 450
let argv : string list = Array.to_list Sys.argv

(*user can pick instrument*)
let instruments =
  [
    ("piano", create_instrument "piano");
    ("accordion", create_instrument "accordion");
    ("acoustic_bass", create_instrument "acoustic_bass");
    ("acoustic_grand_piano", create_instrument "acoustic_grand_piano");
    ("acoustic_guitar_nylon", create_instrument "acoustic_guitar_nylon");
    ("acoustic_guitar_steel", create_instrument "acoustic_guitar_steel");
    ("agogo", create_instrument "agogo");
    ("alto_sax", create_instrument "alto_sax");
    ("applause", create_instrument "applause");
    ("bagpipe", create_instrument "bagpipe");
    ("banjo", create_instrument "banjo");
    ("baritone_sax", create_instrument "baritone_sax");
    ("bassoon", create_instrument "bassoon");
    ("bird_tweet", create_instrument "bird_tweet");
    ("blown_bottle", create_instrument "blown_bottle");
    ("brass_section", create_instrument "brass_section");
    ("breath_noise", create_instrument "breath_noise");
    ("bright_acoustic_piano", create_instrument "bright_acoustic_piano");
    ("celesta", create_instrument "celesta");
    ("cello", create_instrument "cello");
    ("choir_aahs", create_instrument "choir_aahs");
    ("church_organ", create_instrument "church_organ");
    ("clarinet", create_instrument "clarinet");
    ("clavinet", create_instrument "clavinet");
    ("contrabass", create_instrument "contrabass");
    ("distortion_guitar", create_instrument "distortion_guitar");
    ("drawbar_organ", create_instrument "drawbar_organ");
    ("dulcimer", create_instrument "dulcimer");
    ("electric_bass_finger", create_instrument "electric_bass_finger");
    ("electric_bass_pick", create_instrument "electric_bass_pick");
    ("electric_grand_piano", create_instrument "electric_grand_piano");
    ("electric_guitar_clean", create_instrument "electric_guitar_clean");
    ("electric_guitar_jazz", create_instrument "electric_guitar_jazz");
    ("electric_guitar_muted", create_instrument "electric_guitar_muted");
    ("electric_piano_1", create_instrument "electric_piano_1");
    ("electric_piano_2", create_instrument "electric_piano_2");
    ("english_horn", create_instrument "english_horn");
    ("fiddle", create_instrument "fiddle");
    ("flute", create_instrument "flute");
    ("french_horn", create_instrument "french_horn");
    ("fretless_bass", create_instrument "fretless_bass");
    ("fx_1_rain", create_instrument "fx_1_rain");
    ("fx_2_soundtrack", create_instrument "fx_2_soundtrack");
    ("fx_3_crystal", create_instrument "fx_3_crystal");
    ("fx_4_atmosphere", create_instrument "fx_4_atmosphere");
    ("fx_5_brightness", create_instrument "fx_5_brightness");
    ("fx_6_goblins", create_instrument "fx_6_goblins");
    ("fx_7_echoes", create_instrument "fx_7_echoes");
    ("fx_8_scifi", create_instrument "fx_8_scifi");
    ("glockenspiel", create_instrument "glockenspiel");
    ("guitar_fret_noise", create_instrument "guitar_fret_noise");
    ("guitar_harmonics", create_instrument "guitar_harmonics");
    ("gunshot", create_instrument "gunshot");
    ("harmonica", create_instrument "harmonica");
    ("harpsichord", create_instrument "harpsichord");
    ("helicopter", create_instrument "helicopter");
    ("honkytonk_piano", create_instrument "honkytonk_piano");
    ("kalimba", create_instrument "kalimba");
    ("koto", create_instrument "koto");
    ("lead_1_square", create_instrument "lead_1_square");
    ("lead_2_sawtooth", create_instrument "lead_2_sawtooth");
    ("lead_3_calliope", create_instrument "lead_3_calliope");
    ("lead_4_chiff", create_instrument "lead_4_chiff");
    ("lead_5_charang", create_instrument "lead_5_charang");
    ("lead_6_voice", create_instrument "lead_6_voice");
    ("lead_7_fifths", create_instrument "lead_7_fifths");
    ("lead_8_bass__lead", create_instrument "lead_8_bass__lead");
    ("marimba", create_instrument "marimba");
    ("melodic_tom", create_instrument "melodic_tom");
    ("music_box", create_instrument "music_box");
    ("muted_trumpet", create_instrument "muted_trumpet");
    ("oboe", create_instrument "oboe");
    ("ocarina", create_instrument "ocarina");
    ("orchestra_hit", create_instrument "orchestra_hit");
    ("orchestral_harp", create_instrument "orchestral_harp");
    ("overdriven_guitar", create_instrument "overdriven_guitar");
    ("pad_1_new_age", create_instrument "pad_1_new_age");
    ("pad_2_warm", create_instrument "pad_2_warm");
    ("pad_3_polysynth", create_instrument "pad_3_polysynth");
    ("pad_4_choir", create_instrument "pad_4_choir");
    ("pad_5_bowed", create_instrument "pad_5_bowed");
    ("pad_6_metallic", create_instrument "pad_6_metallic");
    ("pad_7_halo", create_instrument "pad_7_halo");
    ("pad_8_sweep", create_instrument "pad_8_sweep");
    ("pan_flute", create_instrument "pan_flute");
    ("percussive_organ", create_instrument "percussive_organ");
    ("piccolo", create_instrument "piccolo");
    ("pizzicato_strings", create_instrument "pizzicato_strings");
    ("recorder", create_instrument "recorder");
    ("reed_organ", create_instrument "reed_organ");
    ("reverse_cymbal", create_instrument "reverse_cymbal");
    ("rock_organ", create_instrument "rock_organ");
    ("seashore", create_instrument "seashore");
    ("shakuhachi", create_instrument "shakuhachi");
    ("shamisen", create_instrument "shamisen");
    ("shanai", create_instrument "shanai");
    ("sitar", create_instrument "sitar");
    ("slap_bass_1", create_instrument "slap_bass_1");
    ("slap_bass_2", create_instrument "slap_bass_2");
    ("soprano_sax", create_instrument "soprano_sax");
    ("steel_drums", create_instrument "steel_drums");
    ("string_ensemble_1", create_instrument "string_ensemble_1");
    ("string_ensemble_2", create_instrument "string_ensemble_2");
    ("synth_bass_1", create_instrument "synth_bass_1");
    ("synth_bass_2", create_instrument "synth_bass_2");
    ("synth_brass_1", create_instrument "synth_brass_1");
    ("synth_brass_2", create_instrument "synth_brass_2");
    ("synth_choir", create_instrument "synth_choir");
    ("synth_drum", create_instrument "synth_drum");
    ("synth_strings_1", create_instrument "synth_strings_1");
    ("synth_strings_2", create_instrument "synth_strings_2");
    ("taiko_drum", create_instrument "taiko_drum");
    ("tango_accordion", create_instrument "tango_accordion");
    ("telephone_ring", create_instrument "telephone_ring");
    ("tenor_sax", create_instrument "tenor_sax");
    ("timpani", create_instrument "timpani");
    ("tinkle_bell", create_instrument "tinkle_bell");
    ("tremolo_strings", create_instrument "tremolo_strings");
    ("trombone", create_instrument "trombone");
    ("trumpet", create_instrument "trumpet");
    ("tuba", create_instrument "tuba");
    ("tubular_bells", create_instrument "tubular_bells");
    ("vibraphone", create_instrument "vibraphone");
    ("viola", create_instrument "viola");
    ("violin", create_instrument "violin");
    ("voice_oohs", create_instrument "voice_oohs");
    ("whistle", create_instrument "whistle");
    ("woodblock", create_instrument "woodblock");
    ("xylophone", create_instrument "xylophone");
  ]

let instrument_names = String.concat ";" (List.map fst instruments)
let () = print_endline instrument_names
let list_view_scroll_index = ref 0
let list_view_active = ref 0
let list_view_ex_focus = ref 0
let current_instrument = ref "piano"
let volume_slider = ref 5.0

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
         "piano")
  in
  let octave_keys =
    [
      Keyboard.init_decrease_octave_key;
      Keyboard.init_increase_octave_key;
    ]
  in
  set_target_fps 60;
  (metronome, !keys, octave_keys, volume_control)

let rec loop
    metronome
    keys
    octave_keys
    (volume_control : unit -> float ref) =
  if Raylib.window_should_close () then Raylib.close_window ()
  else
    let open Raylib in
    begin_drawing ();
    clear_background Color.gray;
    draw_text "OCaml Keyboard" 10 10 20 Color.white;

    let keys =
      Keyboard.refresh
        (Rectangle.create 0.
           (float_of_int (Raylib.get_screen_height ()) -. 100.)
           (float_of_int (Raylib.get_screen_width ()))
           100.)
        !current_instrument false
    in

    draw_text
      ("Current Instrument: " ^ !current_instrument)
      275 12 18 Color.gold;
    (List.iter (fun key -> key ())) keys;
    (List.iter (fun key -> key ())) octave_keys;
    metronome ();
    let volume = volume_control () in
    volume_slider := !volume;

    (* Adjust volume as needed *)
    Raygui.(
      set_style (Slider `Text_color_normal)
        (Raylib.color_to_int Raylib.Color.gold));
    let rect = Rectangle.create 625.0 50.0 150.0 20.0 in
    let volume_slider_val =
      Raygui.slider rect "VOLUME"
        (Printf.sprintf "%1.1f" !volume_slider)
        !volume_slider ~min:0.0 ~max:10.0
    in
    volume_slider := volume_slider_val;
    let () = set_master_volume (!volume_slider /. 10.) in
    let volume_control = Volume.start !volume_slider in

    let rect = Rectangle.create 10. 40. 150. 300. in
    let new_list_view_active, new_focus, new_list_view_scroll_index =
      Raygui.list_view_ex rect
        (List.map fst instruments)
        !list_view_ex_focus !list_view_scroll_index !list_view_active
    in
    list_view_active := new_list_view_active;
    list_view_scroll_index := new_list_view_scroll_index;
    list_view_ex_focus := new_focus;
    if !list_view_active == -1 then list_view_active := 0;
    let selected_instrument =
      List.nth instruments !list_view_active |> fst
    in
    if selected_instrument <> !current_instrument then begin
      current_instrument := selected_instrument;

      let keys =
        Keyboard.refresh
          (Rectangle.create 0.
             (float_of_int (Raylib.get_screen_height ()) -. 100.)
             (float_of_int (Raylib.get_screen_width ()))
             100.)
          !current_instrument true
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
