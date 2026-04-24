#include <cuda_runtime.h>
#include <iostream>

int main() {
    int n; cudaGetDeviceCount(&n);
    std::cout << "Device count: " << n << "\n";
    for (int i = 0; i < n; ++i) {
        cudaDeviceProp p; cudaGetDeviceProperties(&p, i);
        std::cout << "GPU " << i << ": " << p.name << "\n";
        std::cout << "Compute capability: " << p.major << "." << p.minor << "\n";
        std::cout << "Max threads per block: " << p.maxThreadsPerBlock << "\n";
        std::cout << "Max block dim: [" << p.maxThreadsDim[0] << "," << p.maxThreadsDim[1] << "," << p.maxThreadsDim[2] << "]\n";
        std::cout << "Max grid dim: [" << p.maxGridSize[0] << "," << p.maxGridSize[1] << "," << p.maxGridSize[2] << "]\n";
        std::cout << "Global memory: " << (p.totalGlobalMem / (1024*1024)) << " MB\n";
        std::cout << "Shared memory/block: " << (p.sharedMemPerBlock / 1024) << " KB\n";
        std::cout << "Constant memory: " << (p.totalConstMem / 1024) << " KB\n";
        std::cout << "Warp size: " << p.warpSize << "\n";
        std::cout << "Double precision supported: " << ((p.major >= 1 && p.minor >= 3) ? "Yes" : "No") << "\n\n";
    }
    return 0;
}
