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

let data_to_string (w, (x, y, z)) = w ^ "," ^ tuple_to_string (x, y, z)
