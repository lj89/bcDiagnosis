use mydb;

select *  from biopsy;

select *
from biopsy
limit 10
;

select *
from biopsy
limit 10
;

SELECT JSON_ARRAYAGG(JSON_OBJECT(
"radius_mean",radius_mean,
"texture_mean",texture_mean,
"perimeter_mean",perimeter_mean,
"area_mean",area_mean,
"smoothness_mean",smoothness_mean,
"compactness_mean",compactness_mean,
"concavity_mean",concavity_mean,
"concave_points_mean",concave_points_mean,
"symmetry_mean",symmetry_mean,
"fractal_dimension_mean",fractal_dimension_mean,
"radius_se",radius_se,
"texture_se",texture_se,
"perimeter_se",perimeter_se,
"area_se",area_se,
"smoothness_se",smoothness_se,
"compactness_se",compactness_se,
"concavity_se",concavity_se,
"concave_points_se",concave_points_se,
"symmetry_se",symmetry_se,
"fractal_dimension_se",fractal_dimension_se,
"radius_worst",radius_worst,
"texture_worst",texture_worst,
"perimeter_worst",perimeter_worst,
"area_worst",area_worst,
"smoothness_worst",smoothness_worst,
"compactness_worst",compactness_worst,
"concavity_worst",concavity_worst,
"concave_points_worst",concave_points_worst,
"symmetry_worst",symmetry_worst,
"fractal_dimension_worst",fractal_dimension_worst
)) as newPatient from biopsy
where Patient_ID=9047
;