type t = {
  name : string;
  mutable songs : Song.t list;
}

let create name = { name; songs = [] }
let is_empty playlist = List.length playlist.songs == 0
let get_name playlist = playlist.name
let add_song playlist song = playlist.songs <- song :: playlist.songs

let rec filter p = function
  | [] -> []
  | h :: t -> if p h then h :: filter p t else filter p t

let remove_song playlist song_title =
  playlist.songs <-
    filter (fun song -> Song.title song <> song_title) playlist.songs

let rec exists p = function [] -> false | a :: l -> p a || exists p l

let contains playlist song_title =
  exists (fun song -> Song.title song = song_title) playlist.songs

let seconds_to_minutes seconds = (seconds / 60, seconds mod 60)

let time_to_string (time : int * int) =
  let hours, minutes = time in
  let padded_minutes =
    if minutes < 10 then "0" ^ string_of_int minutes
    else string_of_int minutes
  in
  string_of_int hours ^ ":" ^ padded_minutes

let rec fold_left f accu l =
  match l with [] -> accu | a :: l -> fold_left f (f accu a) l

let total_duration (playlist : t) =
  let total_seconds =
    fold_left
      (fun acc song -> acc + Song.duration song)
      0 playlist.songs
  in
  "Total Duration: " ^ time_to_string (seconds_to_minutes total_seconds)

let rec map f = function [] -> [] | h :: t -> f h :: map f t

let display playlist =
  if is_empty playlist then "Playlist is empty."
  else
    fold_left
      (fun acc x -> x ^ "\n" ^ acc)
      ""
      (map (fun song -> Song.to_string_detailed song) playlist.songs)

let get_songs playlist = playlist.songs
