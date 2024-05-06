(* Function to save the contents of an array to a file *)
let save_array_to_file filename arr =
  let oc = open_out filename in
  Array.iter (fun x -> output_string oc (x ^ "\n")) arr;
  close_out oc

(*prints string to filename for saving saved to saved.txt after
  converting it to string*)
let print_string_to_file filename str =
  let out_channel =
    open_out_gen [ Open_append; Open_creat ] 0o666 filename
  in
  output_string out_channel str;
  close_out out_channel

(* Function to load the contents of an array from a file *)
let load_array_from_file filename =
  try
    let ic = open_in filename in
    let rec read_lines acc =
      try
        let line = input_line ic in
        let parts = String.split_on_char ',' line in
        match parts with
        | w :: x :: y :: z :: _ ->
            let str_w = w in
            let float_x = float_of_string x in
            let float_y = float_of_string y in
            let str_z = z in
            read_lines ((str_w, (float_x, float_y, str_z)) :: acc)
        | _ -> read_lines acc (* Ignore malformed lines *)
      with End_of_file -> List.rev acc
    in
    let lines = read_lines [] in
    close_in ic;
    ref (Array.of_list lines)
  with Sys_error _ ->
    ref [||] (* Default value if the file doesn't exist *)

(*converts tuple to string, mainly to allow program to easily convert
  string in file back to original array*)
let tuple_to_string (x, y, z) =
  string_of_float x ^ "," ^ string_of_float y ^ "," ^ z ^ "\n"

let ass_to_string (w, (x, y, z)) = w ^ "," ^ tuple_to_string (x, y, z)

(*converts array to string, for storing saved in file *)
let array_to_string arr =
  let str = ref "" in
  for i = 0 to Array.length arr - 1 do
    str := !str ^ ass_to_string arr.(i)
  done;
  !str

(*converting string back to tuples*)
let string_to_tuple str =
  let len = String.length str in
  let x_start = 1 in
  let y_start = String.index_from str x_start ',' + 1 in
  let z_end = len - 1 in
  let x =
    float_of_string (String.sub str x_start (y_start - x_start - 1))
  in
  let y =
    float_of_string (String.sub str y_start (z_end - y_start - 1))
  in
  let z = String.sub str (y_start + 1) (z_end - y_start - 1) in
  (x, y, z)

(*converting string produced by array_to_string back to the original
  array*)
let string_to_array str =
  let rec parse_string str idx len acc =
    if idx >= len then acc
    else
      let next_tuple_end = String.index_from str idx ')' in
      let tuple_str = String.sub str idx (next_tuple_end - idx + 1) in
      let tuple = string_to_tuple tuple_str in
      parse_string str (next_tuple_end + 1) len (tuple :: acc)
  in
  let len = String.length str in
  let tuples = parse_string str 0 len [] in
  ref (Array.of_list (List.rev tuples))
