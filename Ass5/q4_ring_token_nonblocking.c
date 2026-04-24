#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank, size; 
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int token = 0;
    int next = (rank + 1) % size;
    int prev = (rank - 1 + size) % size;
    MPI_Request reqs[2];

    if (rank == 0) token = 1;

    MPI_Irecv(&token, 1, MPI_INT, prev, 99, MPI_COMM_WORLD, &reqs[0]);
    if (rank == 0) {
        MPI_Isend(&token, 1, MPI_INT, next, 99, MPI_COMM_WORLD, &reqs[1]);
        MPI_Wait(&reqs[1], MPI_STATUS_IGNORE);
    }

    MPI_Wait(&reqs[0], MPI_STATUS_IGNORE);
    token += rank;
    MPI_Isend(&token, 1, MPI_INT, next, 99, MPI_COMM_WORLD, &reqs[1]);
    MPI_Wait(&reqs[1], MPI_STATUS_IGNORE);

    if (rank == 0) printf("Ring completed\n");
    MPI_Finalize();
    return 0;
}
