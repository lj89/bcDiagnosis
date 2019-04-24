## Abstract
In this project, we propose to build a proof-of-concept Integrated Relational Database for Precision Medicine. We integrate data from a variety of sources, such as patient phenotyping data, biopsy data, patient genome sequencing data or genotyping data and major genomic database data such as UCSC and RefSeq, for this database. The first step is designing ER diagram and use normalization techniques to improve the efficiency for storing and querying the data. Then we populate patient genotyping data by simulated data and patient biopsy data from online data source. We also demonstrate the database function by writing SQL queries to extract or subset for deeper analysis. Moreover, we built an Online Prediction Platform by REST API which deployed machine learning model (RandomForestClassifier) for breast cancer diagnosis prediction, so that the patients can get the prediction of their diagnosis by simply type in their Patient-IDs on website.  For next step, we propose to integrate more data from different sources such as Proteomics data or environmental factors data. In addition, it is also feasible to connect our database to more outside databases such as GTEx and TCGA.  For real life large datasets, we propose a Cloud-based AutoDeepLearning Platform for integrative analysis of NGS, WES, and clinical data to predict the subtypes of cancer (DNNClassifier in TensorFlow).

## Index Terms
Precision Medicine, Relational Database, SQL, Bioinformatics Databases, Genomic testing, REST API, Machine Learning, Cancer Diagnosis Prediction


## YouTube link for presentaiton video
https://www.youtube.com/watch?v=dWcdzYX3ZLc
