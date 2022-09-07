import cv2
from PIL import Image
import torch
import numpy as np
import matplotlib.pyplot as plt
def show_image(img):
    temp = Image.fromarray(img)
    temp.show()

def count_objects(path):
    img = cv2.imread(path,cv2.IMREAD_UNCHANGED)
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 10, 1.0)
    flattened = img.reshape((-1))
    flattened = np.float32(flattened)
    K = 2
    attempts = 10
    ret, label, center = cv2.kmeans(flattened,K,None,criteria,attempts,cv2.KMEANS_RANDOM_CENTERS)
    center = np.uint8(center)
    print(center)
    res = center[label.flatten()]
    result_image = res.reshape(img.shape)

    figure_size = 15
    plt.figure(figsize=(figure_size, figure_size))
    plt.subplot(1, 2, 1), plt.imshow(img)
    plt.title('Original Image'), plt.xticks([]), plt.yticks([])
    plt.subplot(1, 2, 2), plt.imshow(result_image)
    plt.title('Segmented Image when K = %i' % K), plt.xticks([]), plt.yticks([])
    plt.show()

if __name__ == '__main__':
    count_objects("images/midterm_problem2_example.png")