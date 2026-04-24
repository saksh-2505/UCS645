#include <cuda_runtime.h>
#include <iostream>

__global__ void sums_kernel(int n, long long *out) {
    if (threadIdx.x == 0) {
        long long s = 0;
        for (int i = 1; i <= n; ++i) s += i;
        out[0] = s;
    }
    if (threadIdx.x == 1) {
        out[1] = 1LL * n * (n + 1) / 2;
    }
}

int main() {
    int N = 1024;
    long long *d_out, h_out[2];
    cudaMalloc(&d_out, 2 * sizeof(long long));
    sums_kernel<<<1, 32>>>(N, d_out);
    cudaMemcpy(h_out, d_out, 2 * sizeof(long long), cudaMemcpyDeviceToHost);
    std::cout << "Iterative sum: " << h_out[0] << "\n";
    std::cout << "Formula sum:   " << h_out[1] << "\n";
    cudaFree(d_out);
    return 0;
}
