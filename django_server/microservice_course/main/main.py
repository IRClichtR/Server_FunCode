from flask import Flask, request
from flask_cors import CORS 
from sqlalchemy import UniqueConstraint
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)  # Création de l'application Flask
app.config["SQLALCHEMY_DATABASE_URI"] = 'mysql://root:root@main_db/main'
CORS(app)

db = SQLAlchemy(app)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=False)
    title = db.Column(db.String(200))
    image = db.Column(db.String(200))


class ProductUser(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    product_id = db.Column(db.Integer)

    UniqueConstraint('user_id', 'product_id', name='user_product_unique')


@app.route('/')

# def log_request_info():
#     app.logger.debug('Headers: %s', request.headers)
#     return 'Logged headers', 200

def index():
    return "Hello Flask!"  # Définition de la route et de la vue

if __name__ == "__main__":  # Vérification correcte pour exécuter l'application
    app.run(debug=True, host='0.0.0.0', port=5001)  # Exécution de l'application Flask

