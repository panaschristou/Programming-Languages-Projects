(****************************************************************)
(*                        BINARY HELPERS                        *)
(****************************************************************)

(**
  int_to_signed_binary: Convert an integer in [-128..127]
  into an 8-bit two’s complement representation as a list of bits,
  in MSB-first order.
  
  Example:
    5   -> 00000101 → [0;0;0;0;0;1;0;1]
    -3  -> 11111101 → [1;1;1;1;1;1;0;1]
*)
let int_to_signed_binary (n : int) : int list =
  let x = n land 0xFF in
  [ (x lsr 7) land 1;
    (x lsr 6) land 1;
    (x lsr 5) land 1;
    (x lsr 4) land 1;
    (x lsr 3) land 1;
    (x lsr 2) land 1;
    (x lsr 1) land 1;
    x land 1 ]

(**
  signed_binary_to_int: Convert an 8-bit two’s complement list
  (MSB-first) into an integer in [-128..127].
  
  It folds over the list from left (MSB) to right.
*)
let signed_binary_to_int (bits : int list) : int =
  let x = List.fold_left (fun acc b -> (acc lsl 1) lor b) 0 bits in
  if x >= 128 then x - 256 else x

(**
  int_to_unsigned_binary: Convert an integer in [0..255]
  into an 8-bit binary list (MSB-first).
*)
let int_to_unsigned_binary (n : int) : int list =
  let x = n land 0xFF in
  [ (x lsr 7) land 1;
    (x lsr 6) land 1;
    (x lsr 5) land 1;
    (x lsr 4) land 1;
    (x lsr 3) land 1;
    (x lsr 2) land 1;
    (x lsr 1) land 1;
    x land 1 ]

(**
  unsigned_binary_to_int: Convert an 8-bit binary list (MSB-first)
  into an integer in [0..255].
*)
let unsigned_binary_to_int (bits : int list) : int =
  List.fold_left (fun acc b -> (acc lsl 1) lor b) 0 bits

(****************************************************************)
(*                        PRINTING BITS                         *)
(****************************************************************)

(**
  string_of_bits: Convert a list of bits (MSB-first) into a string.
  E.g., [0;0;0;0;0;1;0;1] becomes "00000101".
*)
let string_of_bits (bits : int list) : string =
  String.concat "" (List.map (fun b -> if b = 0 then "0" else "1") bits)

let print_binary_8bit label bits =
  Printf.printf "%s (binary 8-bit): %s\n" label (string_of_bits bits)

(****************************************************************)
(*                 BINARY ARITHMETIC (8-bit)                    *)
(****************************************************************)

(**
  add_8bit: Add two 8-bit signed numbers (MSB-first).
  
  To perform addition properly:
    1. Reverse both lists so that the LSB is first.
    2. Add bit-by-bit with carry.
    3. Reverse the result back to MSB-first order.
    
  Overflow (in two’s complement) is detected when the sign of the result
  does not match the signs of the operands (when both operands have the same sign).
*)
let add_8bit (a : int list) (b : int list) : (int list * bool) =
  let a_rev = List.rev a in
  let b_rev = List.rev b in
  let rec add_rev a b carry =
    match (a, b) with
    | ([], []) -> []  (* We ignore an extra carry; result is 8 bits *)
    | (ah :: at, bh :: bt) ->
         let sum = ah + bh + (if carry then 1 else 0) in
         let bit = sum land 1 in
         let newcarry = (sum lsr 1) = 1 in
         bit :: add_rev at bt newcarry
    | _ -> failwith "Lists must be of equal length"
  in
  let result_rev = add_rev a_rev b_rev false in
  let result = List.rev result_rev in
  let a_int = signed_binary_to_int a in
  let b_int = signed_binary_to_int b in
  let r_int = signed_binary_to_int result in
  let overflow =
    (a_int >= 0 && b_int >= 0 && r_int < 0) ||
    (a_int < 0 && b_int < 0 && r_int >= 0)
  in
  (result, overflow)

(**
  sub_8bit: Compute a - b using two’s complement.
  This is done by negating b (inverting bits and adding 1) and then adding.
*)
let sub_8bit (a : int list) (b : int list) : (int list * bool) =
  let invert bits = List.map (fun x -> if x = 0 then 1 else 0) bits in
  let (neg_b, _) = add_8bit (invert b) (int_to_unsigned_binary 1) in
  add_8bit a neg_b

(****************************************************************)
(*                     BITWISE OPERATIONS                       *)
(****************************************************************)

(**
  Bitwise operations work directly on the MSB-first lists.
*)
let and_8bit (a : int list) (b : int list) : int list =
  List.map2 (fun x y -> if x = 1 && y = 1 then 1 else 0) a b

let or_8bit (a : int list) (b : int list) : int list =
  List.map2 (fun x y -> if x = 1 || y = 1 then 1 else 0) a b

let xor_8bit (a : int list) (b : int list) : int list =
  List.map2 (fun x y -> if x <> y then 1 else 0) a b

let not_8bit (a : int list) : int list =
  List.map (fun x -> if x = 0 then 1 else 0) a

(****************************************************************)
(*                    UTILITY: PRINTING, I/O                    *)
(****************************************************************)

let prompt_string msg =
  print_string msg;
  flush stdout;
  read_line ()

(****************************************************************)
(*                        MAIN LOGIC                            *)
(****************************************************************)

let rec main_loop () =
  Printf.printf "\nAvailable operations: ADD, SUB, AND, OR, XOR, NOT, QUIT\n";
  let op = prompt_string "Please specify operation: " in
  let op = String.uppercase_ascii op in
  match op with
  | "QUIT" ->
      Printf.printf "Exiting the program. Goodbye!\n";
      exit 0
  | "ADD" | "SUB" ->
      let a_str = prompt_string "Enter first operand (decimal in -128..127): " in
      let b_str = prompt_string "Enter second operand (decimal in -128..127): " in
      (try
         let a_int = int_of_string a_str in
         let b_int = int_of_string b_str in
         if a_int < -128 || a_int > 127 || b_int < -128 || b_int > 127 then
           Printf.printf "Error: operands must be in [-128..127].\n"
         else
           let a_bits = int_to_signed_binary a_int in
           let b_bits = int_to_signed_binary b_int in
           print_binary_8bit "Operand A" a_bits;
           print_binary_8bit "Operand B" b_bits;
           let (result_bits, overflow) =
             if op = "ADD" then add_8bit a_bits b_bits
             else sub_8bit a_bits b_bits
           in
           print_binary_8bit "Result" result_bits;
           let result_int = signed_binary_to_int result_bits in
           if overflow then Printf.printf "WARNING: Overflow occurred!\n";
           Printf.printf "Result in decimal: %d\n" result_int
       with Failure _ ->
         Printf.printf "Invalid numeric input. Please try again.\n");
      main_loop ()
  | "AND" | "OR" | "XOR" ->
      let a_str = prompt_string "Enter first operand (hex 00..FF, no '0x' prefix): " in
      let b_str = prompt_string "Enter second operand (hex 00..FF, no '0x' prefix): " in
      (try
         let a_int = int_of_string ("0x" ^ a_str) in
         let b_int = int_of_string ("0x" ^ b_str) in
         if a_int < 0 || a_int > 255 || b_int < 0 || b_int > 255 then
           Printf.printf "Error: hex operands must be in [00..FF].\n"
         else
           let a_bits = int_to_unsigned_binary a_int in
           let b_bits = int_to_unsigned_binary b_int in
           print_binary_8bit "Operand A" a_bits;
           print_binary_8bit "Operand B" b_bits;
           let result_bits =
             match op with
             | "AND" -> and_8bit a_bits b_bits
             | "OR"  -> or_8bit a_bits b_bits
             | "XOR" -> xor_8bit a_bits b_bits
             | _ -> failwith "Unexpected operation"
           in
           print_binary_8bit "Result" result_bits;
           let result_int = unsigned_binary_to_int result_bits in
           Printf.printf "Result in hex: %02X\n" result_int
       with Failure _ ->
         Printf.printf "Invalid hex input. Please try again.\n");
      main_loop ()
  | "NOT" ->
      let a_str = prompt_string "Enter operand (hex 00..FF, no '0x' prefix): " in
      (try
         let a_int = int_of_string ("0x" ^ a_str) in
         if a_int < 0 || a_int > 255 then
           Printf.printf "Error: operand must be in [00..FF].\n"
         else
           let a_bits = int_to_unsigned_binary a_int in
           print_binary_8bit "Operand" a_bits;
           let result_bits = not_8bit a_bits in
           print_binary_8bit "Result" result_bits;
           let result_int = unsigned_binary_to_int result_bits in
           Printf.printf "Result in hex: %02X\n" result_int
       with Failure _ ->
         Printf.printf "Invalid hex input. Please try again.\n");
      main_loop ()
  | _ ->
      Printf.printf "Unknown operation. Please try again.\n";
      main_loop ()

let () =
  Printf.printf "Simple 8-bit CPU Operations (Functional Style in OCaml)\n";
  main_loop ()
