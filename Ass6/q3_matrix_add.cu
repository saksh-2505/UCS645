#include <cuda_runtime.h>
#include <iostream>
#include <vector>

__global__ void mat_add(const int *A, const int *B, int *C, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int total = n * n;
    if (idx < total) C[idx] = A[idx] + B[idx];
}

int main() {
    int n = 1024;
    int total = n * n;
    std::vector<int> hA(total, 1), hB(total, 2), hC(total, 0);
    int *dA, *dB, *dC;
    cudaMalloc(&dA, total * sizeof(int));
    cudaMalloc(&dB, total * sizeof(int));
    cudaMalloc(&dC, total * sizeof(int));

    cudaMemcpy(dA, hA.data(), total * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, hB.data(), total * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256, blocks = (total + threads - 1) / threads;
    mat_add<<<blocks, threads>>>(dA, dB, dC, n);
    cudaMemcpy(hC.data(), dC, total * sizeof(int), cudaMemcpyDeviceToHost);

    long long flops = total; // one addition per element
    long long reads = 2LL * total; // A and B
    std::cout << "FLOPs: " << flops << "\n";
    std::cout << "Global memory reads: " << reads << "\n";
    std::cout << "Sample C[0]=" << hC[0] << " C[last]=" << hC.back() << "\n";

    cudaFree(dA); cudaFree(dB); cudaFree(dC);
    return 0;
}
