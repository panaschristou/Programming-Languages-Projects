(**
   A simple 8-bit “CPU Operations” Calculator in OCaml.
   Demonstrates:
   - Signed 8-bit arithmetic (Addition, Subtraction)
   - Unsigned 8-bit logical ops (AND, OR, XOR, NOT)
   - Binary representation as lists of 0/1
   - Input parsing from terminal
   - Output formatting in decimal or hex
   - Recursion instead of loops
*)

(* --------------------------------------------------------------------- *)
(*  Utility: Converting between decimal <-> 8-bit binary (two's complement)*)
(* --------------------------------------------------------------------- *)

(** 
  dec_to_bin: Convert a signed integer (-128..127 in two's complement)
  to an 8-bit list of 0/1. The head of the list is the most significant bit.
*)
let dec_to_bin (n : int) : int list =
  let v = n land 0xFF in
  let rec build_bits idx acc =
    if idx < 0 then acc
    else
      let bit = (v lsr idx) land 1 in
      build_bits (idx - 1) (acc @ [bit])
  in
  build_bits 7 []

(** 
  bin_to_dec: Interpret an 8-bit list of 0/1 as a two's complement integer 
  in range -128..127.
  Assumes the head of the list is the MSB. 
*)
let bin_to_dec (bits : int list) : int =
  match bits with
  | [b7; b6; b5; b4; b3; b2; b1; b0] ->
    (* Combine bits into an integer from 0..255 *)
    let unsigned_val =
      (b7 lsl 7) lor (b6 lsl 6) lor (b5 lsl 5) lor (b4 lsl 4)
      lor (b3 lsl 3) lor (b2 lsl 2) lor (b1 lsl 1) lor (b0 lsl 0)
    in
    (* If the top (sign) bit is 1 => interpret as negative => subtract 256 *)
    if b7 = 1 then unsigned_val - 256 else unsigned_val
  | _ -> failwith "bin_to_dec requires exactly 8 bits"

(* --------------------------------------------------------------------- *)
(*  Utility: Converting between hex <-> 8-bit binary (unsigned)          *)
(* --------------------------------------------------------------------- *)

(** 
  hex_to_bin: Convert a string in the form "0xAB" to an 8-bit list of bits (unsigned).
*)
let hex_to_bin (s : string) : int list =
  (* Strip "0x" if present, or handle raw hex digits. *)
  let hex_str =
    if String.length s >= 2 && String.sub s 0 2 = "0x"
    then String.sub s 2 (String.length s - 2)
    else s
  in
  (* Convert hex string to an integer 0..255 *)
  let int_val = int_of_string ("0x" ^ hex_str) in
  (* Build an 8-bit list from int_val (0..255) *)
  let rec build_bits idx acc =
    if idx < 0 then acc
    else
      let bit = (int_val lsr idx) land 1 in
      build_bits (idx - 1) (acc @ [bit])
  in
  build_bits 7 []

(** 
  bin_to_hex: Convert an 8-bit list of bits (unsigned) to a hexadecimal string "0x..".
*)
let bin_to_hex (bits : int list) : string =
  match bits with
  | [b7; b6; b5; b4; b3; b2; b1; b0] ->
    let value =
      (b7 lsl 7) lor (b6 lsl 6) lor (b5 lsl 5) lor (b4 lsl 4)
      lor (b3 lsl 3) lor (b2 lsl 2) lor (b1 lsl 1) lor b0
    in
    Printf.sprintf "0x%02X" value
  | _ -> failwith "bin_to_hex requires exactly 8 bits"

(* --------------------------------------------------------------------- *)
(*  8-bit Signed Arithmetic (Add / Sub)                                  *)
(* --------------------------------------------------------------------- *)

(** 
  add_8bit: adds two 8-bit *signed* values (given as bit-lists), 
  producing an 8-bit bit-list result (two's complement).
  We simply convert to int, add, then convert back.
  Overflow is by wrapping in 8 bits, as typical in 8-bit CPU arithmetic.
*)
let add_8bit (a_bits : int list) (b_bits : int list) : int list =
  let a = bin_to_dec a_bits in
  let b = bin_to_dec b_bits in
  let sum = a + b in
  (* Wrap in 8 bits with two's complement *)
  dec_to_bin sum

(** 
  sub_8bit: subtract two 8-bit *signed* values (a - b).
  We do the same as add, just with negative.
*)
let sub_8bit (a_bits : int list) (b_bits : int list) : int list =
  let a = bin_to_dec a_bits in
  let b = bin_to_dec b_bits in
  let diff = a - b in
  dec_to_bin diff

(* --------------------------------------------------------------------- *)
(*  8-bit Unsigned Logical Operations                                    *)
(* --------------------------------------------------------------------- *)

(** 
   and_8bit: bitwise AND for 8-bit lists (0..255).
   We interpret them as unsigned, do (land), convert back.
*)
let and_8bit (x_bits : int list) (y_bits : int list) : int list =
  let x = bin_to_dec x_bits in  (* bin_to_dec yields signed -128..127, 
                                   but we only set bits so effectively 0..255 if MSB=0 *)
  let x_u = x land 0xFF in
  let y = bin_to_dec y_bits in
  let y_u = y land 0xFF in
  let res = x_u land y_u in
  dec_to_bin res

(** 
   or_8bit: bitwise OR (unsigned).
*)
let or_8bit (x_bits : int list) (y_bits : int list) : int list =
  let x_u = (bin_to_dec x_bits) land 0xFF in
  let y_u = (bin_to_dec y_bits) land 0xFF in
  dec_to_bin (x_u lor y_u)

(** 
   xor_8bit: bitwise XOR (unsigned).
*)
let xor_8bit (x_bits : int list) (y_bits : int list) : int list =
  let x_u = (bin_to_dec x_bits) land 0xFF in
  let y_u = (bin_to_dec y_bits) land 0xFF in
  dec_to_bin (x_u lxor y_u)

(** 
   not_8bit: bitwise NOT (unsigned).
*)
let not_8bit (x_bits : int list) : int list =
  let x_u = (bin_to_dec x_bits) land 0xFF in
  dec_to_bin (lnot x_u land 0xFF)

(* --------------------------------------------------------------------- *)
(*  Parsing and Evaluating Input                                         *)
(* --------------------------------------------------------------------- *)

(**
  parse_arithmetic: parse an expression like "12 + 5" or "-10 - 3".
  Returns (left_operand, operator, right_operand) as integers and a char for the operator.
*)
let parse_arithmetic (line : string) : (int * char * int) =
  (* Very simplistic parsing:
     Split by spaces, expect something like: [left; op; right].
     We do no advanced error checking here.
  *)
  let parts = String.split_on_char ' ' line in
  match parts with
  | [left_str; op_str; right_str] ->
    let left_val = int_of_string left_str in
    let right_val = int_of_string right_str in
    let op = op_str.[0] in
    (left_val, op, right_val)
  | _ ->
    failwith "Arithmetic parse error: please input like: 12 + 5"

(**
  parse_logic: parse an expression like "0xAA AND 0xFF"
  Returns (left_hex, operator, right_hex).
  Or for unary op like "NOT 0xAF", it might parse differently.
*)
let parse_logic (line : string) : (string * string * string option) =
  let parts = String.split_on_char ' ' line in
  match parts with
  | [op; hex_str] when String.uppercase_ascii op = "NOT" ->
    (* unary operation: NOT 0x?? *)
    ("", "NOT", Some hex_str)
  | [left_hex; op; right_hex] ->
    (left_hex, String.uppercase_ascii op, Some right_hex)
  | _ ->
    failwith "Logic parse error: please input like: 0xAF AND 0x10 or NOT 0xAA"

(**
  evaluate_arithmetic: given a line of arithmetic input (e.g. "12 + 5"),
  produce the decimal string result of the operation.
*)
let evaluate_arithmetic (line : string) : string =
  let (left_val, op, right_val) = parse_arithmetic line in
  let left_bits = dec_to_bin left_val in
  let right_bits = dec_to_bin right_val in
  let result_bits =
    match op with
    | '+' -> add_8bit left_bits right_bits
    | '-' -> sub_8bit left_bits right_bits
    | _   -> failwith "Unknown arithmetic operator"
  in
  let result_val = bin_to_dec result_bits in
  string_of_int result_val

(**
  evaluate_logic: given a line of logic input (e.g. "0xAB AND 0xF0" or "NOT 0xAA"),
  produce the hex string result.
*)
let evaluate_logic (line : string) : string =
  let (left_hex, op, right_opt) = parse_logic line in
  match op with
  | "NOT" ->
    (match right_opt with
     | Some hex_str ->
       let x_bits = hex_to_bin hex_str in
       bin_to_hex (not_8bit x_bits)
     | None -> failwith "Missing operand for NOT")
  | "AND" | "OR" | "XOR" ->
    (match right_opt with
     | Some right_hex ->
       let left_bits = hex_to_bin left_hex in
       let right_bits = hex_to_bin right_hex in
       let res_bits = 
         match op with
         | "AND" -> and_8bit left_bits right_bits
         | "OR"  -> or_8bit left_bits right_bits
         | "XOR" -> xor_8bit left_bits right_bits
         | _     -> failwith "Impossible"
       in
       bin_to_hex res_bits
     | None -> failwith "Missing right operand for binary logical op")
  | _ -> failwith "Unknown logical operator"

(**
  is_hex_input: tries to detect if the input line is for logical ops (contains "0x" or "AND"/"OR"/"XOR"/"NOT")
*)
let is_hex_input (line : string) : bool =
  let uline = String.uppercase_ascii line in
  String.contains uline 'X'
  || (String.contains uline 'A' && (String.length uline < 4 || String.sub uline 0 3 = "AND"))
  || (String.contains uline 'O' && (String.length uline < 3 || String.sub uline 0 2 = "OR"))
  || (String.contains uline 'N' && (String.length uline < 4 || String.sub uline 0 3 = "NOT"))
  || (String.contains uline 'X' && String.contains uline 'O' && String.contains uline 'R')

(**
  main_loop: a simple recursive read-eval-print. 
  We do NOT use loops or mutable variables. We use recursion.
*)
let rec main_loop () =
  print_string "> ";
  let line = try read_line () with End_of_file -> "" in
  if line = "" then
    (* exit the loop on empty input *)
    print_endline "Goodbye."
  else 
    let _ =
      (* Decide if it's arithmetic or logic and evaluate accordingly. *)
      let trimmed = String.trim line in
      if is_hex_input trimmed then
        let result = evaluate_logic trimmed in
        Printf.printf "%s\n" result
      else
        let result = evaluate_arithmetic trimmed in
        Printf.printf "%s\n" result
    in
    main_loop ()

(* Entry point *)
let () =
  print_endline "Simple 8-bit CPU Ops Calculator (type empty line to quit).";
  main_loop ()
