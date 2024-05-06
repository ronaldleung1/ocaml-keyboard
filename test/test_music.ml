open OUnit2
open Music
open Raylib

(* TESTS FOR SONG MODULE *)

let test_create _ =
  let song = Song.create "song1" "artist1" 240 in
  assert_equal "song1" (Song.title song);
  assert_equal "artist1" (Song.artist song);
  assert_equal 240 (Song.duration song)

let test_seconds_to_minutes _ =
  assert_equal (4, 0) (Song.seconds_to_minutes 240);
  assert_equal (4, 29) (Song.seconds_to_minutes 269)

let test_time_to_string _ =
  assert_equal "4:00" (Song.time_to_string (4, 0));
  assert_equal "4:05" (Song.time_to_string (4, 5))

let test_to_string _ =
  let song = Song.create "Blinding Lights" "The Weeknd" 200 in
  assert_equal "Blinding Lights, The Weeknd, 3:20" (Song.to_string song)

let test_create_playlist _ =
  let pl = Playlist.create "My Playlist" in
  assert_equal "My Playlist" (Playlist.get_name pl);
  assert_equal true (Playlist.is_empty pl)

let test_add_song _ =
  let pl = Playlist.create "My Playlist" in
  let song = Song.create "Song" "Artist" 180 in
  Playlist.add_song pl song;
  assert_equal true (Playlist.contains pl "Song")

let test_remove_song _ =
  let pl = Playlist.create "My Playlist" in
  let song = Song.create "Song" "Artist" 180 in
  Playlist.add_song pl song;
  Playlist.remove_song pl "Song";
  assert_equal false (Playlist.contains pl "Song")

let test_total_duration _ =
  let pl = Playlist.create "My Playlist" in
  let song1 = Song.create "Song1" "Artist1" 180 in
  let song2 = Song.create "Song2" "Artist2" 125 in
  Playlist.add_song pl song1;
  Playlist.add_song pl song2;
  assert_equal "Total Duration: 5:05" (Playlist.total_duration pl)

(* TESTS FOR KEYBOARD MODULE *)

(* initializing the keyboard should change the current octave to what
   the input octave is *)
let test_curr_octave _ =
  let octave_before = 5 in
  let _ =
    Keyboard.init_keyboard octave_before
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano" false
  in
  assert_equal octave_before !Octave.curr_octave

(* refreshing the keyboard should not change the current octave because
   no action has been done to increase or decrease the octave *)
let test_curr_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano" false
  in
  let octave_before = !Octave.curr_octave in
  let _ =
    Keyboard.refresh
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano" false true true
  in
  let octave_after = !Octave.curr_octave in
  assert_equal octave_before octave_after

(* init_keyboard cannot be called twice *)
let test_init_keyboard _ =
  let octave = 5 in
  let _ =
    Keyboard.init_keyboard octave
      (Rectangle.create 0. 0. 0. 0.)
      "piano" false
  in
  let octave_changed = 6 in
  assert_raises (Failure "Lists have different lengths") (fun () ->
      Keyboard.init_keyboard octave_changed
        (Rectangle.create 0. 0. 0. 0.)
        "cello" false)

(* refresh_keyboard cannot be called before init_keyboard *)
let test_refresh_keyboard _ =
  assert_raises (Failure "Lists have different lengths") (fun () ->
      Keyboard.refresh (Rectangle.create 0. 0. 0. 0.) "piano" false)

(* refresh_keyboard should not change the number of keys on the
   keyboard *)
let test_refresh_keyboard2 _ =
  let init_keyboard =
    Keyboard.init_keyboard 5
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano" true
  in
  let refresh_keyboard =
    Keyboard.refresh
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "cello" true true true
  in
  assert_equal
    (List.length init_keyboard)
    (List.length refresh_keyboard)

(* creating the increase octave key should not mean octave is
   increased *)
let test_increase_octave _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano" true
  in
  let octave = !Octave.curr_octave in
  let _ = Octave.init_increase_button in
  assert_equal octave !Octave.curr_octave

(* creating the decrease octave key should not mean octave is
   decreased *)
let test_decrease_octave _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano" true
  in
  let octave = !Octave.curr_octave in
  let _ = Octave.init_decrease_button in
  assert_equal octave !Octave.curr_octave

(* test decrease octave key functionality: must not increase the
   octave *)
let test_decrease_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  let current_octave = !Keyboard.curr_octave in
  assert_equal true (current_octave <= octave)

(* test decrease octave key functionality: cannot go beyond 0 on
   curr_octave - 0 on keyboard scale *)
let test_decrease_octave3 _ =
  let _ =
    Keyboard.init_keyboard 1 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  assert_equal true (!Keyboard.curr_octave >= 0)

(* test increase octave key functionality: must not decrease the
   octave *)
let test_increase_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ = Keyboard.init_decrease_octave_key in
  assert_equal octave !Keyboard.curr_octave

(* test decrease octave key functionality: must not increase the
   octave *)
let test_decrease_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  let current_octave = !Keyboard.curr_octave in
  assert_equal true (current_octave <= octave)

(* test decrease octave key functionality: cannot go beyond 0 on
   curr_octave - 0 on keyboard scale *)
let test_decrease_octave3 _ =
  let _ =
    Keyboard.init_keyboard 1 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave > 1 then
      Keyboard.curr_octave := !Keyboard.curr_octave - 1
  in
  assert_equal true (!Keyboard.curr_octave >= 0)

(* test increase octave key functionality: must not decrease the
   octave *)
let test_increase_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave < 5 then
      Keyboard.curr_octave := !Keyboard.curr_octave + 1
  in
  let current_octave = !Keyboard.curr_octave in
  assert_equal true (current_octave >= octave)

(* test increase octave key functionality: cannot go beyond 5 on
   curr_octave - 6 on keyboard scale *)
let test_increase_octave3 _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave < 5 then
      Keyboard.curr_octave := !Keyboard.curr_octave + 1
  in
  let _ =
   fun _ ->
    if !Keyboard.curr_octave < 5 then
      Keyboard.curr_octave := !Keyboard.curr_octave + 1
  in
  assert_equal true (!Keyboard.curr_octave <= 5)

(* TESTS FOR BUTTON MODULE *)

(* when initialized, button stack should have a length of 27,
   corresponding to the number of keys on two octaves and one note on
   the third, and two octave keys *)
let test_button_stack_invariant _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  assert_equal 27 (List.length !Button.button_stack)

(* creating a button with create_general should increase the button
   stack by 1 *)
let test_create_general_with_key_binding _ =
  let initial_length = List.length !Button.button_stack in
  let func =
    Button.create_general_with_key_binding Raylib.Key.A 0 0 100 50
      (fun () -> ())
  in
  let _ = func in
  let final_length = List.length !Button.button_stack in
  assert_equal (initial_length + 1) final_length

(* creating a button with create should increase the button stack by
   1 *)
let test_create_music_button _ =
  let initial_length = List.length !Button.button_stack in
  let foo_rect = Rectangle.create 0. 0. 0. 0. in
  let func =
    Button.create "foo" [ Raylib.Key.A ] [ "foo" ] foo_rect "foo"
  in
  let _ = func in
  let final_length = List.length !Button.button_stack in
  assert_equal (initial_length + 1) final_length

(* creating a bunch of buttons should still keep track of all of them *)
let test_a_bunch_of_buttons _ =
  let initial_length = List.length !Button.button_stack in
  let foo_rect = Rectangle.create 0. 0. 0. 0. in
  for i = 1 to 20 do
    let func =
      Button.create
        ("button" ^ string_of_int i)
        [ Raylib.Key.A ] [ "foo" ] foo_rect "foo"
    in
    let _ = func in
    ()
  done;
  let final_length = List.length !Button.button_stack in
  assert_equal (initial_length + 20) final_length

(* creating just a rectangle not through the create methods will not
   keep track of that rectangle *)
let test_not_legit_button _ =
  let initial_length = List.length !Button.button_stack in
  let foo_rect = Rectangle.create 0. 0. 0. 0. in
  let _ = foo_rect in
  let final_length = List.length !Button.button_stack in
  assert_equal initial_length final_length

(* a rectangle in the same place as the previous button is not the
   previous button - checks for physical equality *)
let test_collision_dup _ =
  let button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = button in
  let button_rect = Rectangle.create 100. 100. 200. 50. in
  let mouse_point = Vector2.create 150. 125. in
  let is_inside =
    Button.check_collision mouse_point button_rect !Button.button_stack
  in
  assert_equal false is_inside

(* if the mouse point is in the dimension of the newest button, the
   newest button must be colliding with mouse point *)
let test_collision_newest_button _ =
  let button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = button in
  let list = !Button.button_stack in
  let newest_button = List.hd list in
  let mouse_point = Vector2.create 150. 125. in
  let is_inside =
    Button.check_collision mouse_point newest_button
      !Button.button_stack
  in
  assert_equal true is_inside

(* if a previous button is covered by a new button, the mouse point will
   not be inside the previous button *)
let test_collision_old_button _ =
  let old_button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = old_button in
  let list = !Button.button_stack in
  let previous_button = List.hd list in
  let mouse_point = Vector2.create 150. 125. in
  let new_button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = new_button in
  let is_inside =
    Button.check_collision mouse_point previous_button
      !Button.button_stack
  in
  assert_equal false is_inside

(* if the mouse point is not inside the newest button, collision will
   not return true for the newest button *)
let test_collison_not_inside_newest_button _ =
  let button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = button in
  let list = !Button.button_stack in
  let newest_button = List.hd list in
  let mouse_point = Vector2.create 0. 0. in
  let is_inside =
    Button.check_collision mouse_point newest_button
      !Button.button_stack
  in
  assert_equal false is_inside

(* if the mouse point is not inside the newest button but is inside a
   previous button not covered by the newest button, collision will
   return true for the previous button *)
let test_collision_inside_old_button_but_with_new_button _ =
  let old_button =
    Button.create_general_with_key_binding Raylib.Key.A 100 100 200 50
      (fun () -> ())
  in
  let _ = old_button in
  let list = !Button.button_stack in
  let previous_button = List.hd list in
  let mouse_point = Vector2.create 100. 100. in
  let new_button =
    Button.create_general_with_key_binding Raylib.Key.A 101 101 200 50
      (fun () -> ())
  in
  let _ = new_button in
  let is_inside =
    Button.check_collision mouse_point previous_button
      !Button.button_stack
  in
  assert_equal true is_inside

(* let test_collision2 _ = let button_rect = Rectangle.create 100. 100.
   200. 50. in let mouse_point = Vector2.create 300. 200. in let
   is_inside = Rectangle.check_collision_point button_rect mouse_point
   in assert_equal false is_inside

   let test_collision3 _ = let button_rect = Rectangle.create 100. 100.
   200. 50. in let mouse_point = Vector2.create 250. 75. in let
   is_inside = Rectangle.check_collision_point button_rect mouse_point
   in assert_equal false is_inside

   let test_collision4 _ = let button_rect = Rectangle.create 100. 100.
   200. 50. in let mouse_point = Vector2.create 100. 100. in let
   is_inside = Rectangle.check_collision_point button_rect mouse_point
   in assert_equal true is_inside *)

let tests =
  [
    "test suite for song module"
    >::: [
           "test_create_song" >:: test_create_song;
           "test_seconds_to_minutes" >:: test_seconds_to_minutes;
           "test_time_to_string" >:: test_time_to_string;
           "test_to_string" >:: test_to_string;
         ];
    "test suite for playlist module"
    >::: [
           "test_create_playlist" >:: test_create_playlist;
           "test_add_song" >:: test_add_song;
           "test_remove_song" >:: test_remove_song;
           "test_total_duration" >:: test_total_duration;
         ];
    "test suite for keyboard module"
    >::: [
           "test_refresh_keyboard" >:: test_refresh_keyboard;
           "test_init_keyboard x curr_keyboard" >:: test_init_keyboard;
           "test_curr_octave x init_keyboard" >:: test_curr_octave;
           "test_curr_octave x refresh" >:: test_curr_octave2;
           "test_init_keyboard" >:: test_init_keyboard;
           "test_refresh_keyboard x init_keyboard "
           >:: test_refresh_keyboard2;
           "test_init_increase_octave_key" >:: test_increase_octave;
           "test_init_decrease_octave_key" >:: test_decrease_octave;
           "test_decrease_octave_invariant" >:: test_decrease_octave2;
           "test_decrease_octave_functionality"
           >:: test_decrease_octave3;
           "test_increase_octave_invariant" >:: test_increase_octave2;
           "test_increase_octave_functionality"
           >:: test_increase_octave3;
         ];
    "test suite for button module"
    >::: [
           "test_button_stack_invariant" >:: test_button_stack_invariant;
           "test_button_stack_and_general_button"
           >:: test_create_general_with_key_binding;
           "test_button_stack_and_music_button"
           >:: test_create_music_button;
           "test adding a bunch of buttons" >:: test_a_bunch_of_buttons;
           "test client not adding buttons the way intended will not \
            work as intended" >:: test_not_legit_button;
           "test_collision_with_duplicate rectangles"
           >:: test_collision_dup;
           "test_collision_with_newest_button"
           >:: test_collision_newest_button;
           "test_collision_with_a_previous_button"
           >:: test_collision_old_button;
           "test mouse point not inside newest button"
           >:: test_collison_not_inside_newest_button;
           "test mouse point inside a previous button but with a new \
            button"
           >:: test_collision_inside_old_button_but_with_new_button;
         ];
  ]

let _ = List.iter (fun test -> run_test_tt_main test) tests
