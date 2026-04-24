import torch

if not torch.cuda.is_available():
    print("CUDA not available.")
    raise SystemExit

x = torch.randn(1 << 20, device="cuda")
# reduction
sum_val = x.sum()
# rough bandwidth estimate using copy timing
start = torch.cuda.Event(enable_timing=True)
end = torch.cuda.Event(enable_timing=True)
start.record()
y = x.clone()
end.record()
torch.cuda.synchronize()
ms = start.elapsed_time(end)
bytes_moved = x.numel() * x.element_size()
bw_gbps = (bytes_moved / (ms / 1000.0)) / 1e9
print("Reduction:", float(sum_val))
print(f"Approx bandwidth: {bw_gbps:.2f} GB/s")
