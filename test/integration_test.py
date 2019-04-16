# Beware the paths when running this script from the Pi

import numpy as np
from PIL import Image
from keras.models import load_model

model = load_model('data/model_tres_performant.h5')

img_car = Image.open('data/car.jpg')
img_car_array = np.array(img_car).reshape((1, 128, 128, 3))

img_not_car = Image.open('data/not_car.jpg')
img_not_car_array = np.array(img_car).reshape((1, 128, 128, 3))

# Should output 0
print(model.predict_classes(img_car_array))

# Should output 1
print(model.predict_classes(img_not_car_array))
