#include <cuda_runtime.h>
#include <iostream>
#include <vector>

__global__ void reduce_sum(const float *in, float *out, int n) {
    extern __shared__ float s[];
    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    s[tid] = (i < n) ? in[i] : 0.0f;
    __syncthreads();

    for (int stride = blockDim.x / 2; stride > 0; stride >>= 1) {
        if (tid < stride) s[tid] += s[tid + stride];
        __syncthreads();
    }
    if (tid == 0) out[blockIdx.x] = s[0];
}

int main() {
    int n = 1 << 20;
    std::vector<float> h(n, 1.0f);
    float *d_in, *d_partial;
    int threads = 256;
    int blocks = (n + threads - 1) / threads;

    cudaMalloc(&d_in, n * sizeof(float));
    cudaMalloc(&d_partial, blocks * sizeof(float));
    cudaMemcpy(d_in, h.data(), n * sizeof(float), cudaMemcpyHostToDevice);

    reduce_sum<<<blocks, threads, threads * sizeof(float)>>>(d_in, d_partial, n);

    std::vector<float> partial(blocks);
    cudaMemcpy(partial.data(), d_partial, blocks * sizeof(float), cudaMemcpyDeviceToHost);

    double sum = 0;
    for (float v : partial) sum += v;
    std::cout << "Sum = " << sum << "\n";

    cudaFree(d_in);
    cudaFree(d_partial);
    return 0;
}
