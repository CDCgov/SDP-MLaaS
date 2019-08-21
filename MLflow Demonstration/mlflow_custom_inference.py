# Import the libraries needed (keras, pandas, mlflow)
import mlflow.pyfunc
import keras
import keras.models
import pandas as pd
# Subprocess will be used to run the preprocessing script
import subprocess

# Overriding the mlflow.pyfunc.PythonModel class for
# custom inference prediction endpoint
class RNN(mlflow.pyfunc.PythonModel):

    def predict(self, context, model_input):
        import keras
        import keras.models
        # The model weights are loaded
        self.model = keras.models.load_model(context.artifacts['nausea_model'])
        # Call out the preprocessing first
        data = self.preprocess(model_input)
        import pandas as pd
        data = pd.read_csv('/home/kemeyer/demo/rnn/preprocessor/proccessed_sample.csv')
        data = data.iloc[:,1:101] # Do not include label column
        return self.model.predict_classes(data)

    def preprocess(self, inp):
        import subprocess
        # Write incoming data to csv for processing
        with open('/home/kemeyer/demo/rnn/input.csv', 'w') as csv:
            for i in inp:
                csv.write("%s\n" % i)

        # This calls the preprocessing script from Task 1
        subprocess.call(["Rscript", "/home/kemeyer/demo/rnn/preprocessor/synthetic_data_script.R"])
        return inp

artifacts = {'nausea_model' : '/home/kemeyer/demo/rnn/nausea_model.h5'}
mlflow.pyfunc.save_model(dst_path='./rnn_demo3', python_model=RNN(), artifacts = artifacts)

# To use the saved model locally, open a python shell and use load_pyfunc
#loaded_model = mlflow.pyfunc.load_pyfunc('./rnn_demo3')