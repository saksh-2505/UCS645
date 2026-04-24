#include <cuda_runtime.h>
#include <algorithm>
#include <chrono>
#include <iostream>
#include <random>
#include <vector>

__global__ void odd_even_step(int *arr, int n, int phase) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int idx = 2 * i + phase;
    if (idx + 1 < n && arr[idx] > arr[idx + 1]) {
        int t = arr[idx]; arr[idx] = arr[idx + 1]; arr[idx + 1] = t;
    }
}

void cpu_merge_sort(std::vector<int>& a) {
    std::stable_sort(a.begin(), a.end());
}

int main() {
    const int n = 1000;
    std::vector<int> h(n);
    std::mt19937 rng(42);
    for (int &x : h) x = rng() % 5000;

    auto cpu = h;
    auto t1 = std::chrono::high_resolution_clock::now();
    cpu_merge_sort(cpu);
    auto t2 = std::chrono::high_resolution_clock::now();

    int *d;
    cudaMalloc(&d, n * sizeof(int));
    cudaMemcpy(d, h.data(), n * sizeof(int), cudaMemcpyHostToDevice);

    int threads = 256;
    int blocks = (n / 2 + threads - 1) / threads;
    cudaEvent_t s,e; cudaEventCreate(&s); cudaEventCreate(&e);
    cudaEventRecord(s);
    for (int phase = 0; phase < n; ++phase) {
        odd_even_step<<<blocks, threads>>>(d, n, phase % 2);
    }
    cudaEventRecord(e); cudaEventSynchronize(e);

    float ms = 0; cudaEventElapsedTime(&ms, s, e);
    std::vector<int> gpu(n);
    cudaMemcpy(gpu.data(), d, n * sizeof(int), cudaMemcpyDeviceToHost);

    bool ok = std::is_sorted(gpu.begin(), gpu.end());
    auto cpu_ms = std::chrono::duration<double, std::milli>(t2 - t1).count();
    std::cout << "CPU sort time (ms): " << cpu_ms << "\n";
    std::cout << "GPU baseline sort time (ms): " << ms << "\n";
    std::cout << "Sorted correctly: " << (ok ? "Yes" : "No") << "\n";

    cudaFree(d);
    return 0;
}
