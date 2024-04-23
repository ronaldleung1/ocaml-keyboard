open OUnit2
open Music

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

let tests =
  "test suite"
  >::: [
         "test_create" >:: test_create;
         "test_seconds_to_minutes" >:: test_seconds_to_minutes;
         "test_time_to_string" >:: test_time_to_string;
         "test_to_string" >:: test_to_string;
       ]

let _ = run_test_tt_main tests
