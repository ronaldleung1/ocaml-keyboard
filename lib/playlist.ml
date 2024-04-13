type t = {
  name : string;
  mutable songs : Song.t list;
}

let create name = { name; songs = [] }
let add_song playlist song = playlist.songs <- song :: playlist.songs

let remove_song playlist song_title =
  playlist.songs <-
    List.filter
      (fun song -> Song.title song <> song_title)
      playlist.songs

let contains playlist song_title =
  List.exists (fun song -> Song.title song = song_title) playlist.songs

let seconds_to_minutes seconds = (seconds / 60, seconds mod 60)

let time_to_string (time : int * int) =
  let hours, minutes = time in
  let padded_minutes =
    if minutes < 10 then "0" ^ string_of_int minutes
    else string_of_int minutes
  in
  string_of_int hours ^ ":" ^ padded_minutes

let total_duration (playlist : t) =
  let total_seconds =
    List.fold_left
      (fun acc song -> acc + Song.duration song)
      0 playlist.songs
  in
  "Total Duration: " ^ time_to_string (seconds_to_minutes total_seconds)

let display playlist =
  List.fold_left
    (fun acc x -> x ^ "\n" ^ acc)
    ""
    (List.map (fun song -> Song.to_string_detailed song) playlist.songs)
