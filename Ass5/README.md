# Assignment 5 (MPI Part II: Blocking vs Non-Blocking)

Programs included:
1. `q1_blocking_ping_pong.c` - blocking send/recv
2. `q2_nonblocking_ping_pong.c` - non-blocking `MPI_Isend/Irecv`
3. `q3_deadlock_and_fix.c` - shows deadlock-prone pattern and fixed order
4. `q4_ring_token_nonblocking.c` - token passing in ring with non-blocking API

## Build
```bash
mpicc q1_blocking_ping_pong.c -o q1
mpicc q2_nonblocking_ping_pong.c -o q2
mpicc q3_deadlock_and_fix.c -o q3
mpicc q4_ring_token_nonblocking.c -o q4
```

## Run
```bash
mpirun -np 2 ./q1
mpirun -np 2 ./q2
mpirun -np 2 ./q3
mpirun -np 4 ./q4
```
