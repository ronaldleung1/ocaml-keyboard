type t = {
  name : string;
  mutable songs : Song.t list;
}

let create name = { name; songs = [] }
let is_empty playlist = List.length playlist.songs == 0
let get_name playlist = playlist.name
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
    if minutes < 10 then begin
      "0" ^ string_of_int minutes
    end
    else begin
      string_of_int minutes
    end
  in
  string_of_int hours ^ ":" ^ padded_minutes

let total_duration (playlist : t) =
  let total_seconds =
    List.fold_left
      begin
        fun acc song -> acc + Song.duration song
      end
      0 playlist.songs
  in
  "Total Duration: " ^ time_to_string (seconds_to_minutes total_seconds)

let display playlist =
  if is_empty playlist then begin
    "Playlist is empty."
  end
  else begin
    List.fold_left
      begin
        fun acc x -> x ^ "\n" ^ acc
      end
      ""
      begin
        List.map
          (fun song -> Song.to_string_detailed song)
          playlist.songs
      end
  end

let get_songs playlist = playlist.songs
