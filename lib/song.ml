type t = {
  title : string;
  artist : string;
  duration : int;
}

let create title artist duration = { title; artist; duration }
let title song = song.title
let artist song = song.artist
let duration song = song.duration
