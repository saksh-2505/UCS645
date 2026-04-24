# Assignment 6 (CUDA Introduction)

Files:
- `q1_device_query.cu` : queries GPU properties
- `q2_array_sum.cu` : sums float array on GPU
- `q3_matrix_add.cu` : matrix addition and simple FLOP/memory analysis

## Build
```bash
nvcc q1_device_query.cu -o q1
nvcc q2_array_sum.cu -o q2
nvcc q3_matrix_add.cu -o q3
```
