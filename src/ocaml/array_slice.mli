
type 'a slice

exception Bounds of string

val length : 'a slice -> int
(** Length of the slice *)
val get : int -> 'a slice -> 'a
(** Get the value at this index
   @raise Bounds if the index is out of bounds for this slice. *)
val subslice : int -> int -> 'a slice -> 'a slice
(** Create a slice from this slice.
  @raise Bounds if either index is out of bounds *)
val slice : int -> int -> 'a array -> 'a slice
(** Create a slice from an array.
  @raise Bounds if either index is out of bounds for the array *)
val from_full : 'a array -> 'a slice
(** Create a slice covering the entire source array *)
val empty : unit -> 'a slice
(** Create a slice of length 0 *)
val singleton : 'a -> 'a slice
(** Create a slice containing a single element. *)
val concat : 'a slice -> 'a slice -> 'a slice
val map : ('a -> 'b) -> 'a slice -> 'b slice
val map2 : ('a -> 'b -> 'c) -> 'a slice -> 'b slice -> 'c slice
val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b slice -> 'a
val fold_right : ('b -> 'a -> 'a) -> 'b slice -> 'a -> 'a

val concat_to_arr : 'a slice -> 'a slice -> 'a array
val map_to_arr : ('a -> 'b) -> 'a slice -> 'b array
val map2_to_arr : ('a -> 'b -> 'c) -> 'a slice -> 'b slice -> 'c array
 
val unsafe_set : int -> 'a -> 'a slice -> unit
