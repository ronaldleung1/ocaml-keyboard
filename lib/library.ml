(* type t = Playlist.t list

   let empty = [] let add_new_playlist playlist library = playlist ::
   library

   let remove_playlist playlist library = List.filter (fun p ->
   Playlist.get_name p <> playlist) library

   let display library = List.fold_left (fun acc x -> x ^ "\n" ^ acc) ""
   (List.map (fun playlist -> Playlist.get_name playlist) library) *)

type t = { mutable playlists : Playlist.t list }

let empty = { playlists = [] }

let add_new_playlist playlist library =
  library.playlists <-
    playlist :: library.playlists (* Directly modifies the state *)

let remove_playlist name library =
  library.playlists <-
    List.filter (fun p -> Playlist.get_name p <> name) library.playlists

let display library =
  List.fold_left
    (fun acc x -> x ^ "\n" ^ acc)
    ""
    (List.map
       (fun playlist -> Playlist.get_name playlist)
       library.playlists)

let find_playlist name library =
  List.find_opt (fun p -> Playlist.get_name p = name) library.playlists
