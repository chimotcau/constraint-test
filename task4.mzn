int: N = 8;
int: BISHOP = 1; 
int: KNIGHT = 2; 
int: ROOK = 3;  
array[1..3] of int: piece_points = [3, 6, 10];
array[1..N, 1..N] of var 0..3: piece;
var int: total_score = sum(r in 1..N, c in 1..N) (
    if piece[r, c] > 0 then piece_points[piece[r, c]] else 0 endif
);
constraint forall(r in 1..N, c in 1..N) (
    piece[r, c] >= 0 /\ piece[r, c] <= 3
);
constraint forall(r in 1..N) (
    forall(c1 in 1..N, c2 in 1..N where c1 < c2) (
        (piece[r, c1] == 0 \/ piece[r, c2] == 0) \/
        (piece[r, c1] == BISHOP /\ piece[r, c2] == BISHOP)
    ) /\
    forall(c in 1..N) (
        sum(c2 in 1..N) (bool2int(piece[r, c2] == ROOK)) <= 1
    )
);
constraint forall(c in 1..N) (
    forall(r1 in 1..N, r2 in 1..N where r1 < r2) (
        (piece[r1, c] == 0 \/ piece[r2, c] == 0) \/
        (piece[r1, c] == BISHOP /\ piece[r2, c] == BISHOP)
    ) /\
    forall(r in 1..N) (
        sum(r2 in 1..N) (bool2int(piece[r2, c] == ROOK)) <= 1
    )
);
constraint forall(d in -(N - 1)..(N - 1)) (
    sum(r in 1..N where r - d >= 1 /\ r - d <= N) (
        bool2int(piece[r, r - d] == BISHOP)) <= 1
);

constraint forall(d in 2..2 * N) (
    sum(r in 1..N where d - r >= 1 /\ d - r <= N) (
        bool2int(piece[r, d - r] == BISHOP)) <= 1
);
constraint forall(r in 1..N, c in 1..N) (
    piece[r, c] == KNIGHT -> (
        forall(dr, dc in {-2, -1, 1, 2} where abs(dr) != abs(dc)) (
            let {
                var int: nr = r + dr,
                var int: nc = c + dc
            } in
                (nr >= 1 /\ nr <= N /\ nc >= 1 /\ nc <= N) -> (piece[nr, nc] != KNIGHT)
        )
    )
);
solve :: int_search([piece[r, c] | r in 1..N, c in 1..N], first_fail, indomain_max, complete) maximize total_score;
output ["Total Score: " ++ show(total_score) ++ "\n" ++
    concat([if fix(piece[r, c]) == BISHOP then "B "
           else if fix(piece[r, c]) == KNIGHT then "K "
           else if fix(piece[r, c]) == ROOK then "R "
           else ". " endif endif endif ++ (if c == N then "\n" else "" endif) | r in 1..N, c in 1..N])
];
