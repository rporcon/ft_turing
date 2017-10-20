type letter = char
type state = string
type direction = Right | Left
type transition = {read: letter; to_state: state; write: letter; action: direction}

(* Below is an example, normally field are filled by json parsing *)
let name = "unary_sub"
let alphabet = ['1'; '.'; '-'; '=']
let blank = '.'
let states = ["scanright"; "eraseone"; "subone"; "skip"; "HALT"]
let initial = "scanright"
let finals = ["HALT"]
let transitions = [
    ("scanright",
    [
        {read = '.'; to_state = "scanright"; write = '.'; action = Right};
        {read = '1'; to_state = "scanright"; write = '1'; action = Right};
        {read = '-'; to_state = "scanright"; write = '-'; action = Right};
        {read = '='; to_state = "eraseone"; write = '.'; action = Left}
    ]);
    ("eraseone",
    [
        {read = '1'; to_state = "subone"; write = '='; action = Left};
        {read = '-'; to_state = "HALT"; write = '.'; action = Left}
    ])
]

let print_transitions () =
    let ac_to_str ac = 
        if ac = Right then "Right" else "Left"
    in
    let rec parse_trs rd_tr_name trs_lst =
        List.iter (fun x -> match x with
           | {read=rd; to_state=st; write=wr; action=ac} -> (
                Printf.printf ("(%s, %c) -> (%s, %c, %s)\n")
                    (rd_tr_name) (rd) (st) (wr) (ac_to_str(ac));
            )
        ) trs_lst
    in
    List.iter (fun x -> parse_trs (fst x) (snd x)) transitions

let print_intro =
    Printf.printf "\t\t\t\t{--[  %s  ]--}\n" (name);
    print_string "Alphabet : [ "; Print.char_list (alphabet); print_endline " ]";
    print_string "States : [ "; Print.str_list (states); print_endline " ]";
    Printf.printf "Initial : %s\n" (initial);
    print_string "Finals : [ "; Print.str_list (finals); print_endline " ]";
    print_transitions (); (* if not () print_transitions is print before first printf above oO *)
    print_endline "-------------------------------------------------------------"

let launch_tape =
    if Array.length Sys.argv != 2 then
        exit 0;
	let explode s =
		let rec exp i l =
			if i < 0 then l else exp (i - 1) (s.[i] :: l)
        in exp (String.length s - 1) []
    in
    (*maybe error check(Sys.arv.(1)) in other place*)
    let tape = explode Sys.argv.(1) in
    let pos = 0 in
    let print_tape cur_tape cur_pos =
        print_char '[';
        List.iteri (fun i x -> if i = cur_pos then Printf.printf "<%c>" (x)
                        else print_char x) cur_tape
        (* Printf.printf "..................] (%s, %c) -> (%s, %c, %s)" *)
    in
    print_tape tape pos
    (*print current_tape then modify char list in consequence of write transition*)
