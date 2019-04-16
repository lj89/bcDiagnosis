#!flask/bin/python
from flask import Flask
import MySQLdb
from flask import jsonify 
from flask import Flask, abort, request 
import numpy as np
import pickle
from sklearn.ensemble import RandomForestRegressor
import json

import logging
import math

app = Flask(__name__)

@app.route('/')
def index():
    return "This is a sample rest service"


	
def queryPatientRecItem(patientID):
    
    global query_result,e;
    try:
        # Create connection to the MYSQL instance running on the local machine
        ## Change the credentials to match your system
        connection = MySQLdb.Connection(host='localhost', user='newuser_py', passwd='forget2,me', db='mydb')
        cursor = connection.cursor()
        logging.warning("Connection established")
        ## Read the input json from the incoming request
        reqObj = request.json
        logging.warning("Request Object \n %s"%reqObj)
        
        query="SELECT * from biopsy	where Patient_ID=%d;"%int(patientID)
        
        logging.warning(query)
        cursor.execute(query)
        query_result = [ dict(line) for line in [zip([ column[0] for column in cursor.description], row) for row in cursor.fetchall()] ]
    except (Exception, e):
        logging.warning("Error [%r]", (e))
        #sys.exit(1)
    finally:
        if cursor:
            cursor.close()
            
    return query_result
    		
	
#### Rest Service definition for returning the list of actors from sakila.actor table
@app.route('/api/getBCDiagnosis/<patientID>', methods=['GET','POST'])
## This function loads a saved model and predicts house price on the incoming data. 
def predictBCDiagnosis(patientID) :

	# with open("NewPatient.json","r") as fp :
		# inData = json.load(fp)
	#inData_query = jsonify({'patientRec': queryPatientRecItem(patientID)})
	inData = queryPatientRecItem(patientID)[0]
	diagnosis = 0
    
## Load the trained model for prediction
	with open("diagnosisModel.pkl","rb") as fp :
		loadedModel = (pickle.load(fp))
        
	xCols = [u'radius_mean', 
              u'texture_mean', u'perimeter_mean', u'area_mean', 
              u'smoothness_mean', u'compactness_mean', 
              u'concavity_mean',u'concave_points_mean', 
              u'symmetry_mean', u'fractal_dimension_mean',
              u'radius_se', u'texture_se', u'perimeter_se', 
              u'area_se', u'smoothness_se', u'compactness_se', 
              u'concavity_se', u'concave_points_se', 
              u'symmetry_se', u'fractal_dimension_se', 
              u'radius_worst', u'texture_worst', 
              u'perimeter_worst', u'area_worst', 
              u'smoothness_worst', u'compactness_worst', 
              u'concavity_worst', u'concave_points_worst', 
              u'symmetry_worst', u'fractal_dimension_worst']
    
	listVals = list()
    
	for colName in xCols :
		if colName in inData.keys():
			listVals.append(inData[colName])
		else:
			listVals.append(0)
	diagnosis = loadedModel.predict(np.array(listVals).reshape(-1,30))
    
	return jsonify({'PredictedDiagnosis': diagnosis[0]})


	
#### Rest service definition for returning the recommendation for a given Customer ID
#### recommendation model can be as simple as finding the most frequently bought item by that customer or anything else you choose
##  Rest Service to get order details for a particular order
##  http://localhost:5000/api/getPatientRecItem/8670
    
@app.route('/api/getPatientRecItem/<patientID>', methods=['POST','GET'])
def getPatientRecItem(patientID):
   
    return jsonify({'patientRec': queryPatientRecItem(patientID)})
	
	
## Starts the server for serving Rest Services 
if __name__ == '__main__':
app.run(debug=True)