open Array;;
open List;;
open Sys;;
open Random;;

let chars =
  [| 'a'; 'b'; 'c'; 'd'; 'e'
  ; 'f'; 'g'; 'h'; 'i'; 'j'
  ; 'k'; 'l'; 'm'; 'n'; 'o'
  ; 'p'; 'q'; 'r'; 's'; 't'
  ; 'u'; 'v'; 'w'; 'x'; 'y'
  ; 'z' |];;

let nums =
  [| '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9' |];;

let syms = 
  [| '@'; '$'; '^'; '|'; '?'; '*'; '+' |];;

let all_chars = Array.append chars @@ Array.append nums syms;;

let str_exists pred str = 
  let len = String.length str in
  let rec go i = 
    if i = len
      then false
    else if pred str.[i]
      then true
    else go (i+1)
  in go 0;;

let flip f a b = f b a;;

let rec gen_pw length =
  let empty = String.make length 'a' in
  let pw = String.map (fun _ -> all_chars.(Random.int @@ Array.length all_chars)) empty in
  let categories = [nums;chars;syms] in
  if List.for_all (fun cat -> str_exists (flip Array.mem cat) pw) categories
    then pw
    else gen_pw length;;
  
let main () =
  Random.self_init ();
  let length = int_of_string argv.(1) in
  print_endline @@ gen_pw length;;

main ();;
