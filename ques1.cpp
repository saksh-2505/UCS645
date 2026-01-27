#include<stdio.h>
#include<iostream>
#include<omp.h>
#include<vector>
int main(){
    const size_t N = 1 << 16; 
    std::vector<double> X(N, 1.0);
    std::vector<double> Y(N, 2.0);
    int max_threads = omp_get_max_threads();
    double start, end;
    std::cout << "Max available threads: " << max_threads << "\n";
    for (int threads = 2; threads <= max_threads; threads *= 2) {
        omp_set_num_threads(threads);
        start = omp_get_wtime();
        #pragma omp parallel for schedule(static)
        for (int i = 0; i < N; i++) {
            X[i] = 1.0 * X[i] + Y[i];
        }
        end = omp_get_wtime();
        std::cout << "Threads: " << threads << ", Time taken: " << (end - start) << " seconds\n";
    }
    return 0;
}