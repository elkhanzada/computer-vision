import torch
import torch.nn as nn


class DoorLock(nn.Module):
    def __init__(self):
        super().__init__()
        self.f = nn.Sequential(
            nn.Linear(100, 1),
            nn.Sigmoid()
        )
        for p in self.f.parameters():
            p.requires_grad = False

    def forward(self, x):
        y = self.f(x)
        if y > 0.9:
            print('Opened!')
        return y


class DoorHack(nn.Module):
    def __init__(self, locker):
        super().__init__()
        self.g = nn.Sequential(
            nn.Linear(100, 100),
        )
        self.locker = locker

    def forward(self, z):
        y = self.locker(self.g(z))
        return y


if __name__ == '__main__':
    num_trials = 50
    lr = 50
    locker = DoorLock()
    hacker = DoorHack(locker)
    y = torch.randn(1, 100)
    hacker.train()
    target = torch.tensor([1])
    for i in range(num_trials):
        z = torch.tensor(y, requires_grad=True)
        output = hacker(z)
        loss = torch.nn.BCELoss(output, target)
        if output > 0.9:
            print(i)
            break
        output.backward()
        y += lr * z.grad
