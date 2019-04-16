import requests
import json




if __name__ == '__main__':


	# The model is used to predict price of another house. 
	# The features of the house are stored in the json file. 
	with open("NewHouse.json","r") as fp :
		newHouse = json.load(fp)

	## The Restservice URL where the prediction model is hosted
	url = 'http://localhost:5000/api/getSalesPrice'
	response = requests.post(url, data=json.dumps(newHouse),headers={"Content-Type": "application/json"})
	salePriceObj=response.json()  
	print("Predicted Sales Price for the input data : $%s "%salePriceObj["PredictedSalesPrice"])