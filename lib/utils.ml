let rec combine_lists l1 l2 =
  match (l1, l2) with
  | [], [] -> []
  | [], _ | _, [] -> failwith "Lists have different lengths"
  | x :: xs, y :: ys -> (x, y) :: combine_lists xs ys

let map2i f l1 l2 =
  List.map2
    (fun i (x, y) -> f i x y)
    (List.init (List.length l1) Fun.id)
    (combine_lists l1 l2)
