import os
import json
from flask import Flask, render_template

app = Flask(__name__, static_url_path='/static')

@app.route('/')
def index():
    try:
        drinks = json.loads(os.environ['DRINKS'])
    except KeyError:
        drinks = False

    if drinks and drinks['barman']['amount_of_drinks_drunken'] > 15:
        raise RuntimeError("Barman has had too many drinks!")

    return render_template('index.html', drinks=drinks)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)