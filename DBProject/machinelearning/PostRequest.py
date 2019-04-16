import requests
import json




if __name__ == '__main__':


	# The model is used to predict price of another house. 
	# The features of the house are stored in the json file. 
	with open("NewPatient9047.json","r") as fp :
		newPatient = json.load(fp)

	## The Restservice URL where the prediction model is hosted
	url = 'http://localhost:5000/api/getBCDiagnosis'
	response = requests.post(url, data=json.dumps(newPatient),headers={"Content-Type": "application/json"})
	diagnosisObj=response.json()  
	print("Predicted Breast Cancer Diagnosis for Patient is: $%s "%diagnosisObj["PredictedDiagnosis"])