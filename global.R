#read the csv files
library(data.table)

aqi = fread(file='./data/AQI_all.csv')
uv = fread(file='./data/uv_aqi_city.csv')
county_df = fread(file='./data/us_counties.csv')