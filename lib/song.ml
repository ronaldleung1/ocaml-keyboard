type t = {
  title : string;
  artist : string;
  duration : int;
}

let create title artist duration = { title; artist; duration }
let title song = song.title
let artist song = song.artist
let duration song = song.duration
let seconds_to_minutes seconds = (seconds / 60, seconds mod 60)

let time_to_string (time : int * int) =
  let hours, minutes = time in
  let padded_minutes =
    if minutes < 10 then "0" ^ string_of_int minutes
    else string_of_int minutes
  in
  string_of_int hours ^ ":" ^ padded_minutes

let to_string song =
  song.title ^ ", " ^ song.artist ^ ", "
  ^ time_to_string (seconds_to_minutes song.duration)

let to_string_detailed song =
  "Title: " ^ song.title ^ ", Artist: " ^ song.artist ^ ", Duration: "
  ^ time_to_string (seconds_to_minutes song.duration)
