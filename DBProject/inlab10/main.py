#!flask/bin/python
from flask import Flask
import MySQLdb
from flask import jsonify 
from flask import Flask, abort, request 
import numpy as np
import pickle
from sklearn.ensemble import RandomForestRegressor


app = Flask(__name__)

@app.route('/')
def index():
    return "This is a sample rest service"


#### Rest Service definition for returning the list of actors from sakila.actor table
@app.route('/api/getSalesPrice', methods=['GET','POST'])
## This function loads a saved model and predicts house price on the incoming data. 
def predictSalePrice() :

	inData = request.json
	salePrice = 0


## Load the trained model for prediction
	with open("SalePriceModel.pkl","rb") as fp :
		loadedModel = pickle.load(fp)
        
	xCols = [u'MSSubClass', u'LotArea', u'OverallQual', u'OverallCond', u'YearBuilt',
       u'YearRemodAdd', u'BsmtFinSF1', u'BsmtFinSF2', u'BsmtUnfSF',
       u'TotalBsmtSF', u'1stFlrSF', u'2ndFlrSF', u'LowQualFinSF', u'GrLivArea',
       u'BsmtFullBath', u'BsmtHalfBath', u'FullBath', u'HalfBath',
       u'BedroomAbvGr', u'KitchenAbvGr', u'TotRmsAbvGrd', u'Fireplaces',
       u'GarageCars', u'GarageArea', u'WoodDeckSF', u'OpenPorchSF',
       u'EnclosedPorch', u'3SsnPorch', u'ScreenPorch', u'PoolArea', u'MiscVal',
       u'MoSold', u'YrSold']
    
	listVals = list()
    
	for colName in xCols :
		if colName in inData.keys():
			listVals.append(inData[colName])
		else:
			listVals.append(0)
	salePrice = loadedModel.predict(np.array(listVals).reshape(-1,33))
    
	return jsonify({'PredictedSalesPrice': salePrice[0]})



## Starts the server for serving Rest Services 
if __name__ == '__main__':
    app.run(debug=True)