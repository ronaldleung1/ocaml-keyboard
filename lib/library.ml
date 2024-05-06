type t = { mutable playlists : Playlist.t list }

let empty = { playlists = [] }
let is_empty library = List.length library.playlists == 0

let add_new_playlist playlist library =
  library.playlists <- playlist :: library.playlists

let remove_playlist name library =
  library.playlists <-
    List.filter (fun p -> Playlist.get_name p <> name) library.playlists

let display library =
  if is_empty library then "Library is empty."
  else
    List.fold_left
      (fun acc x -> x ^ "\n" ^ acc)
      ""
      (List.map
         (fun playlist -> Playlist.get_name playlist)
         library.playlists)

let find_playlist name library =
  List.find_opt (fun p -> Playlist.get_name p = name) library.playlists

let get_playlists library = library.playlists
