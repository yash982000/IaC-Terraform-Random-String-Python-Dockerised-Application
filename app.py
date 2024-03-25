from flask import Flask, jsonify
import random

app = Flask(__name__)

# List of random strings
random_strings = ["Investments", "Smallcase", "Stocks", "buy-the-dip", "TickerTape"]

@app.route('/api/v1', methods=['GET'])
def get_random_string():
    return jsonify({"random_string": random.choice(random_strings)})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8081)
