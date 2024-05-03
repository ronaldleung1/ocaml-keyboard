val combine_lists : 'a list -> 'b list -> ('a * 'b) list
(** [combine_lists l1 l2] combines two lists l1 and l2 into an
    association list. Raises failure if lists have different lengths *)

val map2i : (int -> 'a -> 'b -> 'c) -> 'a list -> 'b list -> 'c list
(** [map2i f l1 l2] maps a function f over two lists l1 and l2, with the
    index of the element as the first argument to f *)
