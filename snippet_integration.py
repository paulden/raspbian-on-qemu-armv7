# Take care of paths for execution to work on the pi

import numpy as np
from PIL import Image
from keras.models import load_model

model = load_model('/path/to/model_tres_performant.h5')
img_car = Image.open('/path/to/car.jpg')
img_car_array = np.array(img_car).reshape((1, 128, 128, 3))

img_not_car = Image.open('/path/to/not_car.jpg')
img_not_car_array = np.array(img_car).reshape((1, 128, 128, 3))

# Should output 0
print(model.predict_classes(img_car_array))

# Should output 1
print(model.predict_classes(img_not_car_array))

