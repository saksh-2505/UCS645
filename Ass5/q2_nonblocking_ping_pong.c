#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    MPI_Init(&argc, &argv);
    int rank; MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    int msg = (rank == 0) ? 100 : 0;
    MPI_Request reqs[2];

    if (rank == 0) {
        MPI_Isend(&msg, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, &reqs[0]);
        MPI_Irecv(&msg, 1, MPI_INT, 1, 1, MPI_COMM_WORLD, &reqs[1]);
        MPI_Waitall(2, reqs, MPI_STATUSES_IGNORE);
        printf("Rank 0 got %d\n", msg);
    } else if (rank == 1) {
        MPI_Irecv(&msg, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &reqs[0]);
        MPI_Wait(&reqs[0], MPI_STATUS_IGNORE);
        msg *= 2;
        MPI_Isend(&msg, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &reqs[1]);
        MPI_Wait(&reqs[1], MPI_STATUS_IGNORE);
    }

    MPI_Finalize();
    return 0;
}
