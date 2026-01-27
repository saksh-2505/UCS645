#include<iostream>
#include<omp.h>
#include <vector>
const int N =1000;
const int REPEAT = 3;
using Matrix = std::vector<std::vector<double>>;

void init(Matrix &M) {
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            M[i][j] = 1.0;
        }
    }
}

void onedcomp(Matrix &A, Matrix &B, Matrix &C) {
    #pragma omp parallel for schedule(static)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            double sum = 0.0;
            for (int k = 0; k < N; k++)
                sum += A[i][k] * B[k][j];
            C[i][j] = sum;
        }
    }}
void twodcomp(Matrix &A, Matrix &B, Matrix &C) {
    #pragma omp parallel for collapse(2) schedule(static)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            double sum = 0.0;
            for (int k = 0; k < N; k++)
                sum += A[i][k] * B[k][j];
            C[i][j] = sum;
        }
    }
}
int main(){
    Matrix A(N, std::vector<double>(N));
    Matrix B(N, std::vector<double>(N));
    Matrix C(N, std::vector<double>(N));
    double start, end;

    init(A);
    init(B);
    int max_threads = omp_get_max_threads();
    std::cout << "Threads, Time_1D(s), Time_2D(s)\n";

    for (int t = 2; t <= max_threads; t *= 2) {
        omp_set_num_threads(t);

        /* -------- 1D timing -------- */
        start = omp_get_wtime();


        for (int r = 0; r < REPEAT; r++)
            onedcomp(A, B, C);
        end = omp_get_wtime();
        double t1 = end - start;

        /* -------- 2D timing -------- */
        start = omp_get_wtime();
        for (int r = 0; r < REPEAT; r++)
            twodcomp(A, B, C);
        end = omp_get_wtime();
        double t2 = end - start;

        std::cout << t << ", " << t1 << ", " << t2 << "\n";
    }

}