#include <cuda_runtime.h>
#include <iostream>
#include <vector>

__global__ void vadd(const float *a, const float *b, float *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

int main() {
    int n = 1 << 20;
    std::vector<float> a(n, 1.5f), b(n, 2.5f), c(n, 0.0f);
    float *da, *db, *dc;
    cudaMalloc(&da, n*sizeof(float));
    cudaMalloc(&db, n*sizeof(float));
    cudaMalloc(&dc, n*sizeof(float));
    cudaMemcpy(da, a.data(), n*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(db, b.data(), n*sizeof(float), cudaMemcpyHostToDevice);

    int threads = 256, blocks = (n + threads - 1) / threads;
    vadd<<<blocks, threads>>>(da, db, dc, n);
    cudaMemcpy(c.data(), dc, n*sizeof(float), cudaMemcpyDeviceToHost);

    std::cout << "c[0]=" << c[0] << ", c[n-1]=" << c.back() << "\n";
    cudaFree(da); cudaFree(db); cudaFree(dc);
    return 0;
}
