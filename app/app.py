#!/usr/bin/env python

from flask import Flask
import sys 
import os
from flask import jsonify
from flask import request
from flask_pymongo import PyMongo
from pymongo import MongoClient

app = Flask(__name__)

mdb_host = os.environ['MDB_HOST'] 
mdb_port =  int(os.environ['MDB_PORT'])
mdb_user = os.environ['MDB_USER'] 
mdb_passwd = os.environ['MDB_PASSWD'] 
client = MongoClient(mdb_host, mdb_port, replicaset='MainRepSet')
database = client.admin.authenticate(mdb_user, mdb_passwd, mechanism='SCRAM-SHA-1')


@app.route('/api/mongodb/showdb', methods=['GET'])
def show_dbs():
    return str({'databases': client.list_database_names()})

@app.route('/api/mongodb/create/<db>', methods=['POST'])
def create_db(db):
    dblist = client.list_database_names()
    if db in dblist:
        return str("The database exists.")
    mydb = client[db]
    mycol = mydb["collection"]
    mydict = {"name": "test_data"}
    mycol.insert_one(mydict)
    return str({'databases' : client.list_database_names()})

@app.route('/api/mongodb/create/<db>/<coll>', methods=['POST'])
def create_coll(db, coll):
    mydb = client[db]
    collist = mydb.list_collection_names()
    if coll in collist:
        return str("collection exists.")
    mycol = mydb[coll]
    mydict = { "name": "test_data"}
    mycol.insert_one(mydict)
    return str({'collections': mydb.list_collection_names()})

@app.route('/api/mongodb/insert/<db>/<coll>', methods=['POST'])
def insert_data(db, coll):
    mydb = client[db]
    mycol = mydb[coll] 
    data = request.json
    mycol.insert(data)
    return str(data)    

@app.route('/api/mongodb/drop/<db>/<coll>', methods=['POST'])
def drop_coll(db, coll):
    mydb = client[db]
    mycol = mydb[coll]
    dblist = client.list_database_names()
    collist = mydb.list_collection_names()
    if db not in dblist:
        return str("The database NOT exists.")
    elif coll not in collist:
        return str("collection NOT exists.")
    mycol.drop()
    return str({'collections': mydb.list_collection_names()})

@app.route('/api/mongodb/find/<db>/<coll>', methods=['GET'])
def find_data(db, coll):
    mydb = client[db]
    mycol = mydb[coll]
    dblist = client.list_database_names()
    collist = mydb.list_collection_names()
    if db not in dblist:
        return str("The database NOT exists.")
    elif coll not in collist:
        return str("collection NOT exists.")
    x = mycol.find({})
    output = [i for i in x] 
    return str({'collections': output})




if __name__ == '__main__':

    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)



