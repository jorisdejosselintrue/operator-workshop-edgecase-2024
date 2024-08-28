from flask import Flask, render_template
import os

app = Flask(__name__)

@app.route('/')
def index():
    # Get the number of drinks from environment variable or default to 5
    number_of_drinks = int(os.getenv('NUMBER_OF_DRINKS', 5))

    # Sample list of drinks
    all_drinks = [
        "Coca Cola", "Pepsi", "Sprite", "Fanta", "Mountain Dew",
        "Dr Pepper", "7 Up", "Ginger Ale", "Root Beer", "Lemonade"
    ]

    # Limit the number of drinks to be displayed
    drinks = all_drinks[:number_of_drinks]

    return render_template('index.html', drinks=drinks)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
