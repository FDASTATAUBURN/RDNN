# Robust Deep Neural Network Estimation for Multi-dimensional Functional Data
------------------------------------------------

# Functional Data Regression Model
![model](https://latex.codecogs.com/gif.latex?Y_%7Bij%7D%20%3Df_0%5Cleft%28%5Cmathbf%7BX%7D_j%5Cright%29%20&plus;%20%5Cepsilon_%7Bi%7D%5Cleft%28%5Cmathbf%7BX%7D_j%5Cright%29%2C%20%7E%7Ei%20%3D%201%2C%202%2C%20%5Cldots%2C%20n%2C%20j%20%3D%201%2C%202%2C%20%5Cldots%2C%20N)
- ![X](https://latex.codecogs.com/gif.latex?%5Cmathbf%7BX%7D_%7Bj%7D%5Cin%20%5Cmathbb%7BR%7D%5Ed): fixed vector of length d for the j-th observational point
- ![Y](https://latex.codecogs.com/gif.latex?Y_%7Bij%7D): scalar random variable for the i-th subject and j-th observational point
- ![n](https://latex.codecogs.com/gif.latex?n): sample size
- ![N](https://latex.codecogs.com/gif.latex?N): number of observational points
- ![f](https://latex.codecogs.com/gif.latex?f_0%3A%20%5Cmathbb%7BR%7D%5Ed%20%5Crightarrow%20%5Cmathbb%7BR%7D): true function to estimate

# Deep Neural Network Model input and output
- Input: ![X](![image](https://user-images.githubusercontent.com/78890608/157989298-e213699b-a8bd-4857-b749-848af8f86add.png)) (uniform among all i for the same j)
- Output: ![Y](https://latex.codecogs.com/gif.latex?Y_%7Bij%7D)
-------------------------------------------------------------

# Deep Neural Network Hyperparameters 
- L: number of layers 
- p: neurons per layer (uniform for all layers)
- s: l1 penalty parameter
- Loss function: square loss/ huber loss/ check loss
- Dropout rate: data dependent
- Batch size: data dependent
- Epoch number: data dependent
- Activation function: ReLU
- Optimizer: Adam 
-------------------------------------------------------------

# Function descriptions
## One dimensional functional data
- "dnn_1d_par.R": hyperparameter selection with training data. More details can be found in comments
- "dnn_1d.R": functional deep neural netowrks. More details can be found in comments 
## Two dimensional functional data
- "dnn_2d_par.R": hyperparameter selection with training data. More details can be found in comments
- "dnn_2d.R": functional deep neural netowrks. More details can be found in comments 
-------------------------------------------------------------

# Examples
- "example_2d.R": 
