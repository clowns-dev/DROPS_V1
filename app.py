from flask import Flask, jsonify, request
import mysql.connector
from flask_cors import CORS
import datetime
import random
import string

app = Flask(__name__)
CORS(app)  

# Configuración de la conexión a la base de datos MySQL
db_config = {
    'user': 'root',         
    'password': '1234',
    'host': 'localhost',     
    'database': 'db_drops',  
}

# Ruta de prueba para verificar la conexión
@app.route('/test', methods=['GET'])
def test():
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()
        cursor.execute("SELECT DATABASE();")
        db_name = cursor.fetchone()[0]
        cursor.close()
        connection.close()
        return jsonify({"message": f"Conectado a la base de datos: {db_name}"})
    except mysql.connector.Error as err:
        return jsonify({"error": str(err)}), 500

# Endpoint para login
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data.get('username')
    password = data.get('password')
    
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    cursor.execute("""
        SELECT u.userName, u.password, r.roleName
        FROM user u
        JOIN role r ON u.idRole = r.idRole
        WHERE u.userName = %s
    """, (username,))
    user = cursor.fetchone()
    
    cursor.close()
    connection.close()

    if user and user['password'] == password:
        return jsonify({"role": user['roleName']})
    else:
        return jsonify({"error": "Credenciales incorrectas"}), 401

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
