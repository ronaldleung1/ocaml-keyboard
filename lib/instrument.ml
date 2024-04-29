(*Rep Invariant: the instrument can only contain name as "brass", "drumkit", "string"*)
type t = {
  name : string
}

let get_name instrument = instrument.name

let create_instrument (name : string) : t = {name}