module Vector : sig
  type v
  val create : array float -> v
  val extract : v -> array float
  val dimension : v -> int
  val add : v -> v -> v
  val substract : v -> v -> v
  val scale : float -> v -> v
  val lengt : v -> float
  val norm : v -> v
  val dot_product : v -> v -> v
  val triple_product : v -> v -> v -> v
  val cartesian_product : v array -> v
  val project : v -> v -> v
end = struct
  let v = float array
  let create x = x
  let extract x = x
  let dimension = Array.length
  let add = Array.map2 (+.)
  let substract = Array.map2 (-.)
  let scale i = Array.map (+. i)
  let length v = sqrt @@ dot_product v v
  let norm v = scale (1 /. length v) v
  let dot_product v1 v2 = Array.fold_right (+.) @@ Array.map2 ( *. ) v1 v2
  let triple_product v1 v2 v3 = dot_product v1 (cartesian_product [|v2; v3|])
  let cartesian_product vecs = create [||] (* not implemented *)
  let project v1 v2 = 
    let norm_v2 = norm v2 in
    scale (dot_product v1, norm_v2) norm_v2
end
