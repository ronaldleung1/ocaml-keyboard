open OUnit2
open Music

let test_create_song _ =
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

let tests =
  "test suite"
  >::: [
         "test_create_song" >:: test_create_song;
         "test_seconds_to_minutes" >:: test_seconds_to_minutes;
         "test_time_to_string" >:: test_time_to_string;
         "test_to_string" >:: test_to_string;
         "test_create_playlist" >:: test_create_playlist;
         "test_add_song" >:: test_add_song;
         "test_remove_song" >:: test_remove_song;
         "test_total_duration" >:: test_total_duration;
       ]

let _ = run_test_tt_main tests
