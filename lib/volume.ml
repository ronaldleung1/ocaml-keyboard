open Raylib

let start (start_volume : float) =
  let volume = ref start_volume in
  fun () ->
    if is_key_down Key.Right then volume := !volume +. 0.1
    else if is_key_down Key.Left then volume := !volume -. 0.1;

    volume := max 0.0 (min 10. !volume);

    (* Display the current volume *)
    let display_volume = Printf.sprintf "Volume: %.1f" !volume in
    draw_text display_volume 700 42 16 Raylib.Color.gold;

    set_master_volume (!volume /. 10.);
    volume
