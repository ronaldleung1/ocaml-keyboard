open OUnit2
open Music
open Raylib

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
      "piano"
  in
  assert_equal octave_before !Keyboard.curr_octave

(* refreshing the keyboard should not change the current octave because
   no action has been done to increase or decrease the octave *)
let test_curr_octave2 _ =
  let _ =
    Keyboard.init_keyboard 5
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano"
  in
  let octave_before = !Keyboard.curr_octave in
  let _ =
    Keyboard.refresh
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "piano" false
  in
  let octave_after = !Keyboard.curr_octave in
  assert_equal octave_before octave_after

(* init_keyboard cannot be called twice *)
let test_init_keyboard _ =
  let octave = 5 in
  let _ =
    Keyboard.init_keyboard octave (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave_changed = 6 in
  assert_raises (Failure "Lists have different lengths") (fun () ->
      Keyboard.init_keyboard octave_changed
        (Rectangle.create 0. 0. 0. 0.)
        "cello")

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
      "piano"
  in
  let refresh_keyboard =
    Keyboard.refresh
      (Rectangle.create 0.
         (float_of_int (Raylib.get_screen_height ()) -. 100.)
         (float_of_int (Raylib.get_screen_width ()))
         100.)
      "cello" true
  in
  assert_equal
    (List.length init_keyboard)
    (List.length refresh_keyboard)

(* creating the increase octave key should not mean octave is
   increased *)
let test_increase_octave _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ = Keyboard.init_increase_octave_key in
  assert_equal octave !Keyboard.curr_octave

(* creating the decrease octave key should not mean octave is
   decreased *)
let test_decrease_octave _ =
  let _ =
    Keyboard.init_keyboard 5 (Rectangle.create 0. 0. 0. 0.) "piano"
  in
  let octave = !Keyboard.curr_octave in
  let _ = Keyboard.init_decrease_octave_key in
  assert_equal octave !Keyboard.curr_octave

let tests =
  [
    "test suite for song module"
    >::: [
           "test_create" >:: test_create;
           "test_seconds_to_minutes" >:: test_seconds_to_minutes;
           "test_time_to_string" >:: test_time_to_string;
           "test_to_string" >:: test_to_string;
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
         ];
  ]

let _ = List.iter (fun test -> run_test_tt_main test) tests
