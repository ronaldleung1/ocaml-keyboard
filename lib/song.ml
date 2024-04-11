type t = {
  title : string;
  artist : string;
  duration : int;
}

let create title artist duration = { title; artist; duration }
let title song = song.title
let artist song = song.artist
let duration song = song.duration

let to_string song =
  song.title ^ ", " ^ song.artist ^ ", " ^ string_of_int song.duration
