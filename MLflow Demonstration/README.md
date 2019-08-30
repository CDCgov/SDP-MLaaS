# Title

This folder contains the files needed to customize MLflow. By default MLflow invokes the predict method associated with a Keras model. The code provided here demonstrates how to override that default behavior. In this example, the Python code invokes a tokenizer that converts from a chief complaint (text) to a word vector, which is then classified using the Keras model.
