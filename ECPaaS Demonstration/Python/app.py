import os
import pickle
import string
import pandas as pd
from flask import Flask, jsonify, request, Blueprint
from flask_restplus import Resource, Api, reqparse
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.models import load_model
from werkzeug.datastructures import FileStorage
import tensorflow as tf

app = Flask(__name__)
app.config.SWAGGER_UI_DOC_EXPANSION = 'list'
# Swagger setup
blueprint = Blueprint('swagger',  __name__, url_prefix="/__swagger__/")
app.register_blueprint(blueprint)
api = Api(app, version='1.0', title='MLaaS',
    description=None,
)

parser = api.parser()
parser.add_argument('description', 
                    type=str, 
                    help='The description of symptoms', 
                    location='args')
parser.add_argument('data', 
                    type=FileStorage, 
                    location='files', 
                    help='A single column CSV with separate symptom descriptions per row (expects header row)')

# Global variables needed
global graph
graph = tf.get_default_graph()
ml_model = load_model("./models/model.h5")
tokenizer = pickle.load(open('./models/tokenizer', 'rb'))


def clean_string(text):
    """
    Helper function intended to remove bad texts
    """
    text = text.replace("0", "ZERO")
    text = text.replace("1", "ONE")
    text = text.replace("2", "TWO")
    text = text.replace("3", "THREE")
    text = text.replace("4", "FOUR")
    text = text.replace("5", "FIVE")
    text = text.replace("6", "SIX")
    text = text.replace("7", "SEVEN")
    text = text.replace("8", "EIGHT")
    text = text.replace("9", "NINE")
    text = text.translate(str.maketrans('', '', string.punctuation))
    return text


def text_process(texts):
    """
    Preprocesses the data and return the sequences to feed into the learner.
    """
    text = map(clean_string, texts)
    seq = tokenizer.texts_to_sequences(text)
    data = pad_sequences(seq, maxlen=100)
    return data


def predict(data, model):
    """
    Generate predictions based on data for a given model in keras.
    """
    res = {"predictions": [], "probabilities": []}
    res["probabilities"] = model.predict(data).flatten().tolist()
    res["predictions"] = model.predict_classes(data).flatten().tolist()
    return res


@api.route('/predict')
class Predict(Resource):
    @api.expect(parser)
    def post(self):
        text = request.args.get("description")
        if text:
            text = text.split(",")
            with graph.as_default():
                data = text_process(text)
                res = predict(data, ml_model)
            return res
        elif request.files.get("data"):
            csv = request.files.get("data")
            csv = pd.read_csv(csv)
            csv.dropna(inplace=True)
            try:
                columns = csv.iloc[:,0]
            except Exception:
                return {
                    "error": "CSV Malformed. Expected single column of strings with ."
                }, 500
            with graph.as_default():
                data = text_process(columns)
                res = predict(data, ml_model)
            return res
        return {
                "error": "Expected parameter 'description' or a CSV (Content-Type: multipart/form-data) in an HTTP post request."
            }, 500


if __name__ == "__main__":
    print("Starting Server")
    app.run(host='0.0.0.0', port='8080')
