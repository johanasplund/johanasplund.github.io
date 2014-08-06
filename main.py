import yaml
import random
from flask import Flask, render_template
from flask_frozen import Freezer
app = Flask(__name__)
app.config.from_pyfile("settings.py")
freezer = Freezer(app)


@app.route("/", methods=["GET", "POST"])
def index():
    color = get_random_color()
    return render_template("index.html",
                           primary=color["primary"],
                           lighter=color["lighter"],
                           darker=color["darker"])


@app.route("/brainfuck")
def brainfuck():
    color = get_random_color()
    return render_template("brainfuck.html", mimetype='text/html',
                           primary=color["primary"],
                           lighter=color["lighter"],
                           darker=color["darker"],
                           darkest=color["darkest"],
                           lightest=color["lightest"])


def get_random_color():
    with open("static/colors.yaml", "r") as f:
        colors_yaml = yaml.load(f)
    return random.choice(colors_yaml["colors"])


if __name__ == "__main__":
    app.run(debug=True)
