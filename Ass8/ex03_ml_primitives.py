import torch
import torch.nn.functional as F

device = "cuda" if torch.cuda.is_available() else "cpu"
logits = torch.randn(8, 5, device=device)
labels = torch.randint(0, 5, (8,), device=device)

relu_out = F.relu(logits)
softmax_out = F.softmax(logits, dim=1)
loss = F.cross_entropy(logits, labels)

print("ReLU shape:", relu_out.shape)
print("Softmax row sums:", softmax_out.sum(dim=1))
print("Cross entropy loss:", float(loss))
