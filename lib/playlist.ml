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
