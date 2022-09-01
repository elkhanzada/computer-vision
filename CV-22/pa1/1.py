import cv2
import torch
from torch import nn
from torch.nn import Sequential, Conv2d, Linear, MaxPool2d, ReLU, Flatten
from torchvision import datasets, transforms
from PIL import Image
import numpy as np
import pytesseract


class ModernLenet(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.model = Sequential(
            Conv2d(1, 6, kernel_size=5, padding=2),
            ReLU(),
            MaxPool2d(2, 2),
            Conv2d(6, 16, kernel_size=5),
            ReLU(),
            MaxPool2d(2, 2),
            Flatten(),
            Linear(400, 120),
            ReLU(),
            Linear(120, 84),
            ReLU(),
            Linear(84, num_classes)
        )

    def forward(self, x):
        x = self.model(x)
        x = torch.nn.functional.log_softmax(x, 1)
        return x


def show_number(path):
    img = cv2.imread(path)
    center = (img.shape[0] / 2, img.shape[1] / 2)
    w, h = 150, 150
    x = center[1] - w / 2
    y = center[0] - h / 2
    crop_img = img[int(y - h):int(y + h), int(x - h):int(x + w)]
    red = crop_img[:, :, 2]
    temp = Image.fromarray(red)
    temp.show()


def crop_image(path):
    img = cv2.imread(path)
    corner = cv2.cornerHarris(img[:, :, 2], 2, 3, 0.04)
    coord = np.where(corner == corner.max())
    print(coord)
    if len(coord) == 1:
        center = coord[0], coord[1]
    else:
        center = coord[0][0], coord[1][0]
    h, w = 28, 28

    crop_img = img[int(center[0] - h):int(center[0] + h), int(center[1] - w):int(center[1] + w)]
    red = crop_img[:, :, 2]
    red[red != red.min()] = 255
    red[red == red.min()] = 0
    return red


def train_mnist(epoch):
    net = ModernLenet()
    net.train()
    device = torch.device("cuda")
    net.to(device)
    transform = transforms.Compose([
        transforms.ToTensor(),
    ])
    train_data = datasets.MNIST("data", train=True, download=True, transform=transform)

    train_loader = torch.utils.data.DataLoader(train_data, batch_size=32)
    optimizer = torch.optim.Adam(params=net.parameters(), lr=0.01)
    for i in range(epoch):
        for batch_idx, (data, target) in enumerate(train_loader):
            data, target = data.to(device), target.to(device)
            optimizer.zero_grad()
            output = net(data)
            loss = torch.nn.functional.nll_loss(output, target)
            loss.backward()
            optimizer.step()
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                i + 1, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader), loss.item()))
    torch.save(net.state_dict(), "model.h5")


def test_mnist():
    net = ModernLenet()
    device = torch.device("cuda")
    net.to(device)
    net.load_state_dict(torch.load("model.h5"))
    net.eval()
    transform = transforms.Compose([
        transforms.ToTensor()
    ])
    test_data = datasets.MNIST("data", train=False, download=True, transform=transform)
    test_loader = torch.utils.data.DataLoader(test_data, batch_size=32)
    test_loss = 0
    correct = 0
    with torch.no_grad():
        for data, target in test_loader:
            data, target = data.to(device), target.to(device)
            output = net(data)
            test_loss += torch.nn.functional.nll_loss(output, target, reduction='sum').item()  # sum up batch loss
            pred = output.argmax(dim=1, keepdim=True)  # get the index of the max log-probability
            correct += pred.eq(target.view_as(pred)).sum().item()

    test_loss /= len(test_loader.dataset)

    print('\nTest set: Average loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))


def check_four(path):
    net = ModernLenet()
    net.load_state_dict(torch.load("model.h5"))
    net.eval()
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Resize((28, 28))
    ])
    net.to(torch.device("cpu"))
    red = crop_image(path)
    red = Image.fromarray(red)
    red.show()
    red = transform(red).unsqueeze(0)
    outputs = net(red)
    pred = outputs.argmax(dim=1, keepdim=True)
    print(pred)


def simple_way(path):
    img = cv2.imread(path)
    red = img[:, :, 2]
    custom_config = r'--oem 3 --psm 6'
    res = pytesseract.image_to_string(red, config=custom_config)
    if '4' in res:
        print('alarm')
    else:
        pass


if __name__ == '__main__':
    simple_way("images/image2.png")
