int: N = 10;
int: MaxBishops = 3;
array[1..N, 1..N] of var 0..1: board;
var int: total_bishops = sum(r in 1..N, c in 1..N) (board[r, c]);
solve maximize total_bishops;
constraint forall(r in 1..N) (
    sum(c in 1..N) (board[r, c]) <= MaxBishops
);
constraint forall(c in 1..N) (
    sum(r in 1..N) (board[r, c]) <= MaxBishops
);
constraint forall(d in -(N - 1)..(N - 1)) (
    sum(r in 1..N where r - d >= 1 /\ r - d <= N) (board[r, r - d]) <= 1
);
constraint forall(d in 2..2 * N) (
    sum(r in 1..N where d - r >= 1 /\ d - r <= N) (board[r, d - r]) <= 1
);
output ["Total Bishops: " ++ show(total_bishops) ++ "\n" ++
    concat([if fix(board[r, c]) == 1 then "B " else ". " endif ++ (if c == N then "\n" else "" endif) | r in 1..N, c in 1..N])
];
