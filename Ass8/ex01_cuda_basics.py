import torch

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print("Device:", device)

x = torch.arange(10, dtype=torch.float32, device=device)
scaled = x * 2.5
sq_diff = (scaled - x) ** 2
print("x:", x)
print("scaled:", scaled)
print("squared diff:", sq_diff)
