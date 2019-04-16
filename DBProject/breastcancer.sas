
proc import datafile = 'C:\Users\lhuang\Documents\DataScience\Database\DBProject\machinelearning\data\bcdatasetForModeling.csv'
 out = bcdatasetForModeling
 dbms = csv
 replace;
run;
data datIn; set bcdatasetForModeling; 
run;


*** scatter plots of trainning data;
title1 "scatter plots of trainning data";   
proc sgscatter data=datIn; 
matrix 
	radius_mean
	texture_mean
	perimeter_mean
	area_mean
	smoothness_mean
	compactness_mean
	concavity_mean
	
	/eclipse=(alpha=.05);
run;


title1 "scatter plots of trainning data";                                                                                        
title2 "with histogram kernel";                                                                                            
proc sgscatter data=datIn;                                                                                                      
  matrix 
	radius_se
	radius_worst
	texture_worst
	smoothness_worst
	compactness_worst
	concavity_worst
	concave_points_worst
	/group=diagnosis 
     diagonal=(histogram kernel);                                                                               
run;                                                                                                                                    
                                                                                                                                        
title1 "histogram of trainning data";   
proc univariate data=datIn;
  class diagnosis;
  var
	radius_se
	radius_worst
	texture_worst
	smoothness_worst
	compactness_worst
	concavity_worst
	concave_points_worst;
  histogram 	
	radius_se
	radius_worst
	texture_worst
	smoothness_worst
	compactness_worst
	concavity_worst
	concave_points_worst
	/group=diagnosis 
 / nrows=3 odstitle="PROC UNIVARIATE with CLASS statement";
  ods select histogram; 
run;
title 'shot_made rate by action_type';
proc sgplot data=datIn;
  hbar action_type / response=shot_made_flag stat=mean group=action_type nostatlabel
         groupdisplay=cluster;
  xaxis display=(nolabel);
  yaxis grid;
  run;

title 'shot_made sum by shot_zone_area';
proc sgplot data=datIn;
  vbar shot_zone_area / response=shot_made_flag stat=sum group=shot_zone_area nostatlabel
         groupdisplay=cluster;
  xaxis display=(nolabel);
  yaxis grid;
  run;

title 'shot_made rate by shot_zone_area';
proc sgplot data=datIn;
  vbar shot_zone_area / response=shot_made_flag stat=mean group=shot_zone_area nostatlabel
         groupdisplay=cluster;
  xaxis display=(nolabel);
  yaxis grid;
  run;

title 'shot_made rate by opponent in period 4';
proc sgplot data=datIn;
  hbar opponent / response=shot_made_flag stat=mean group=opponent nostatlabel
         groupdisplay=cluster;
where period=4;
xaxis display=(nolabel);
  yaxis grid;
  run;

title 'shot_made location by action_type';
proc sgplot data=datIn noautolegend;
  bubble x=loc_x y=loc_y size= shot_made_flag / group=action_type 
    transparency=0.4 datalabelattrs=(size=9 weight=bold);
  inset "Bubble size represents shot_made_flag" / position=bottomright textattrs=(size=11);
  where shot_made_flag=0;
  yaxis grid;
  xaxis grid;
run;


title 'shot_made location by action_type shot_made_flag=0';
proc sgplot data=datIn;
  scatter x=loc_x y=loc_y / group=action_type markerattrs=(size=5px);
  where shot_made_flag=0;
  yaxis grid;
  xaxis grid;
run;

****do shot_made_flag type conversion here for both dataset**************************;
data datIn; set datIn;
shot_made_flag_char = put(shot_made_flag,7.);
drop shot_made_flag;
rename shot_made_flag_char=shot_made_flag;
run;

data datIn_test; set datIn_test;
shot_made_flag_char = put(shot_made_flag,7.);
drop shot_made_flag;
rename shot_made_flag_char=shot_made_flag;
run;



*** Use logistic regression stepwise selection,get the misclassification rate;
proc logistic data=datIn descending plots=all;
  class diagnosis / param=ref ; 
  model diagnosis(event='B') =  	
	radius_mean
	texture_mean
	perimeter_mean
	area_mean
	smoothness_mean
	compactness_mean
	concavity_mean
	concave_points_mean
	symmetry_mean
	fractal_dimension_mean
	radius_se
	texture_se
	perimeter_se
	area_se
	smoothness_se
	compactness_se
	concavity_se
	concave_points_se
	symmetry_se
	fractal_dimension_se
	radius_worst
	texture_worst
	perimeter_worst
	area_worst
	smoothness_worst
	compactness_worst
	concavity_worst
	concave_points_worst
	symmetry_worst
	fractal_dimension_worst /selection=stepwise ctable pprob = .5 ;   
  output out=logisticOut predprobs=I p=predprob resdev=resdev reschi=pearres;
run;

proc freq data =logisticOut; tables diagnosis*_into_/nocol nopercent; run; 


**** after variable selection, build the model manually;
proc logistic data=datIn descending;
  class shot_made_flag   action_type  opponent shot_zone_area / param=ref ; 
  model shot_made_flag(event='1') =  action_type shot_zone_area attendance shot_distance szBasic szRange  
                        time_in_seconds_remaining opponent/ctable pprob = .5 ;   
  output out=logisticOut predprobs=I p=predprob resdev=resdev reschi=pearres;
  *** Score data=datIn_test out = kobe_logisticCategorized;
run;

proc freq data =logisticOut; tables shot_made_flag*_into_/nocol nopercent; run; 

****Output probabilities for observations from proc logistic;
title "Output probabilities for observations from proc logistic";
data logisticOutGraphs; set logisticOut; obsno = _n_; run;

proc plot data=logisticOutGraphs;
 plot resdev*obsno;
 plot pearres*obsno;
run; quit;



**** use final model to do prediction on test dataset;
proc logistic data=datIn descending;
  class shot_made_flag   action_type  opponent shot_zone_area / param=ref ; 
  model shot_made_flag(event='1') =  action_type shot_zone_area attendance shot_distance szBasic szRange  
                        time_in_seconds_remaining opponent/ctable pprob = .5 ;   
  output out=logisticOut predprobs=I p=predprob resdev=resdev reschi=pearres;
  Score data=datIn_test out = kobe_logisticCategorized;
run;

title "Actual by Predicted for Logistic Model";
proc freq data =logisticOut; tables shot_made_flag*_into_/nocol nopercent; run; 


*** use model to test playoffs prediction on test dataset;
proc logistic data=datIn descending;
  class shot_made_flag   action_type  opponent shot_zone_area playoffs/ param=ref ; 
  model shot_made_flag(event='1') =  action_type shot_zone_area attendance shot_distance szBasic szRange  
                        time_in_seconds_remaining opponent playoffs/ctable pprob = .5 ;   
  output out=logisticOut predprobs=I p=predprob resdev=resdev reschi=pearres;
  ***Score data=datIn_test out = kobe_logisticCategorized;
run;

title "Actual by Predicted for Logistic Model";
proc freq data =logisticOut; tables shot_made_flag*_into_/nocol nopercent; run; 

****export predict dataset to file kobePred_logisticCategorized.xlsx ;
proc export 
  data=kobe_logisticCategorized 
  dbms=xlsx 
  outfile="C:\Users\lhuang\Documents\DataScience\AppliedStatistics\project2Spring2019\kobePred_logisticCategorized.xlsx" 
  replace;
run;

title "Actual first 50 obs by Predicted Using Test Data for Logistic Model";
proc print data=kobe_logisticCategorized(obs=50 keep=rannum I_shot_made_flag attendance shot_distance szRange loc_x loc_y time_in_seconds_remaining ); 
run;


**** get ROC curve and Hosmer Lemeshow Goodness of Fit Test;
proc logistic data = datIn order=data plots(MAXPOINTS=NONE) = all;
 class shot_made_flag  shot_type action_type playoffs opponent shot_zone_area / param=ref ; 
 model shot_made_flag(event='1') =  action_type shot_zone_area attendance shot_distance szBasic szRange  
                        time_in_seconds_remaining opponent/ ctable lackfit clparm=wald;                                                                                                                                                                                                                           
 output out = logisticOut predprobs=I p=predprob resdev=resdev reschi=pearres;                                                                                                                                                                                                                          
run;





*** discrim analysis;
proc discrim data=datIn pool=yes out=discrimOut method=normal crossvalidate; 
 class shot_made_flag;
 var 
	arena_temp
	avgnoisedb
	loc_x
	loc_y
	attendance 
	shot_distance 
	szRange 
	szArea 
	szBasic
	actType 
	time_in_seconds_remaining;
 priors prop;
run; 

title "Actual by Predicted for Discriminate Function Model";
***proc freq data =discrimCategorized; *** tables prog*_into_/nocol nopercent; 
proc freq data =discrimOut; tables shot_made_flag*_into_/nocol nopercent;
run; 



*** discrim predict: we don't use;
proc discrim data=datIn pool=yes out=discrimOut testData = datIn_test testout=kobe_discrimCategorized crossvalidate; 
 class shot_made_flag;
 var 
	arena_temp
	avgnoisedb
	loc_x
	loc_y
	attendance 
	shot_distance 
	szRange 
	szArea 
	szBasic
	actType 
	time_in_seconds_remaining;
 priors prop;
run; 



