
type 'a slice = 
  { arr : 'a array
  ; start : int
  ; len : int
  }

exception Bounds of string

let length s = s.len

let unsafe_get i s = s.arr.(i + s.start)

let get i s = 
  if i < 0 || i >= s.len then raise (Bounds "get") else
  unsafe_get i s

let unsafe_subslice s l sl = 
  { sl with start = sl.start + s;
            len = l;
  }

let subslice s e sl =
  if s < 0 || e < 0 || s + e > sl.len then raise (Bounds "subslice") else 
  unsafe_subslice s e sl

let unsafe_slice s e arr =
  { arr = arr
  ; start = s
  ; len = e
  }

let slice s e arr = 
  if s < 0 || e < 0 || s + e > Array.length arr then raise (Bounds "slice") else 
  unsafe_slice s e arr

let from_full arr =
  { arr = arr
  ; start = 0
  ; len = Array.length arr
  }

let empty () = 
  { arr = [||]
  ; start = 0
  ; len = 0
  }

let singleton a = 
  { arr = [|a|]
  ; start = 0
  ; len = 1 
  }

let map_to_arr f sl =
  let l = sl.len in
  if l = 0 then [||] else
  let out_arr = Array.make l (f (unsafe_get 0 sl)) in
  for i = 1 to l - 1 do
    out_arr.(i) <- f (unsafe_get i sl)
  done;
  out_arr

let map f sl = 
  { arr = map_to_arr f sl
  ; start = 0
  ; len = sl.len
  }

let map2_to_arr (f : 'a -> 'b -> 'c) (sl1 : 'a slice) (sl2 : 'b slice) : 'c array =
  let l = sl1.len in
  if l != sl2.len then raise (Bounds "map2") else
  if l = 0 then [||] else
  let out_arr = Array.make l @@ f (unsafe_get 0 sl1) (unsafe_get 0 sl2) in
  for i = 1 to l - 1 do
    out_arr.(i) <- f (unsafe_get i sl1) (unsafe_get i sl2)
  done;
  out_arr

let map2 f sl1 sl2 =
  { arr = map2_to_arr f sl1 sl2
  ; start = 0
  ; len = sl1.len
  }

let fold_left f init sl =
  let r = ref init in
  let a = sl.arr in
  for i = sl.start to sl.start + sl.len - 1 do
    r := f !r a.(i)
  done;
  !r

let fold_right f sl init =
  let r = ref init in
  let a = sl.arr in
  for i = sl.start + sl.len - 1 downto sl.start do
    r := f a.(i) !r
  done;
  !r

let concat_to_arr sl1 sl2 =
  if sl1.len = 0 then sl2 else
  if sl2.len = 0 then sl1 else
  let combined_len = sl1.len + sl2.len in
  let out_arr = Array.make combined_len sl1.(0) in
  let l1 = sl1.len in
  for i = 1 to l1 - 1 do
    out_arr.(i) <- unsafe_get i sl1
  done;
  for i = 0 to sl2.len do
    out_arr.(l1 + i) <- unsafe_get i sl2
  done;
  out_arr

let concat sl1 sl2 = from_full @@ concat_to_arr sl1 sl2

let unchecked_set i e sl =
  sl.arr.(i + sl.start) <- e

let unsafe_set i e sl =
  if i < 0 || i >= sl.len then raise (Bounds "set") else
  unchecked_set i e sl

