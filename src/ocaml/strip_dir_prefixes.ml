
open Sys;;
open String;;
open Array;;
open List;;

let strip_prefix prefix dir =
    if String.length dir < String.length prefix
    then None
    else
        let lp = String.length prefix in
        let start = String.sub dir 0 lp in
        if start = prefix 
            then Some (String.sub dir lp (String.length dir)) 
            else None;;

let main () =
    let prefix = argv.(1) in
    let files = filter is_directory @@ to_list @@ readdir @@ getcwd () in
    List.iter print_string files;
    print_newline ();
    List.iter 
        (fun d -> match strip_prefix prefix d with
            | None -> ()
            | Some new_name -> 
                print_string "renaming to "; 
                print_string new_name; 
                print_newline ();  
                Sys.rename d new_name) 
        files;;

main ();;

