type t = { mutable playlists : Playlist.t list }

let empty = { playlists = [] }
let is_empty library = List.length library.playlists == 0

let add_new_playlist playlist library =
  library.playlists <- playlist :: library.playlists

let rec filter p = function
  | [] -> []
  | h :: t -> if p h then h :: filter p t else filter p t

let remove_playlist name library =
  library.playlists <-
    filter (fun p -> Playlist.get_name p <> name) library.playlists

let rec fold_left f accu l =
  match l with [] -> accu | a :: l -> fold_left f (f accu a) l

let rec map f = function [] -> [] | h :: t -> f h :: map f t

let display library =
  if is_empty library then "Library is empty."
  else
    fold_left
      (fun acc x -> x ^ "\n" ^ acc)
      ""
      (map
         (fun playlist -> Playlist.get_name playlist)
         library.playlists)

let rec find_opt p = function
  | [] -> None
  | x :: l -> if p x then Some x else find_opt p l

let find_playlist name library =
  find_opt (fun p -> Playlist.get_name p = name) library.playlists

let get_playlists library = library.playlists
