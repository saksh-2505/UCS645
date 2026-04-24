#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank; MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int x = rank;

    // Fixed approach using MPI_Sendrecv to avoid deadlock
    int y = -1;
    int peer = 1 - rank;
    MPI_Sendrecv(&x, 1, MPI_INT, peer, 10,
                 &y, 1, MPI_INT, peer, 10,
                 MPI_COMM_WORLD, MPI_STATUS_IGNORE);

    printf("Rank %d sent %d and received %d\n", rank, x, y);
    MPI_Finalize();
    return 0;
}
