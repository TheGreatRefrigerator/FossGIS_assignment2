# FossGIS_assignment2

## 1. Setting up a GitHub repository

1.1 
https://github.com/TheGreatRefrigerator/FossGIS_assignment2/

1.2
`git clone https://github.com/TheGreatRefrigerator/FossGIS_assignment2.git`

## 2. Downloading the data

2.1
administrative data of germany in [data/gadm36_DEU_shp](./data/gadm36_DEU_shp) folder in `.shp` format.
Only the files `gadm36_DEU_2.*` are needed as they contain the correct level of administrative boundaries

2.2
forest and motorway data in [data](./data) folder in `.geojson` format

2.3
queries saved in [data/oms-turbo-query.txt](./data/osm-turbo-query.txt)

## 3. Preprocessing the data

3.1
```sh
# switch to data folder
$ cd data

# use `ogrinfo` to check metadata of files
$ ogrinfo -al -so forest.geojson
$ ogrinfo -al -so highways.geojson
$ ogrinfo -al -so gadm36_DEU_shp/gadm36_DEU_2.shp

# all are EPSG 4326 (WGS 84 aka Webmercator)
```

3.2
as we want to calculate areas we should not use`WGS 84` (degrees) but the UTM complement `UTM zone 32N` (meters) which is `EPSG:32632`.
```sh
$ ogr2ogr -t_srs EPSG:32632 forest_UTM.geojson forest.geojson
$ ogr2ogr -t_srs EPSG:32632 highways_UTM.geojson highways.geojson

# see next step for boundaries
```

3.3
the link to the Blog Post on Extracting Features using ogr2ogr is broken, it took me forever to figure out how to use the `where` parameter.
It is important to use `"` as enclosing quotes and `'` as inner quotes. -.-
```sh
$ ogr2ogr -where "NAME_2 IN ('Heidelberg','Bergstraße','Rhein-Neckar-Kreis','Mannheim')" -t_srs EPSG:32632 gadm36_DEU_shp/selected.shp gadm36_DEU_shp/gadm36_DEU_2.shp
```

3.4
see [preprocessing.bat](./data/preprocessing.bat) in data folder

## 4 (I guess this is step 4) Creating a QGIS model

### 4.1 Creating the model
see 4.2

### 4.2 Add you model to github (3)
model located in [affected_forest_in_motorway_range.model3](./affected_forest_in_motorway_range.model3)

## 5 (maybe?) Executing the model and discussing the results

5.1
sadly the batch process failed with `python/plugins/processing/algs/qgis/FieldsCalculator.py", line 121, in processAlgorithm fields, source.wkbType(), source.sourceCrs()) Exception: unknown `

i had to do single runs, then it worked

| NAME_2             | total forest area | affected forest fraction (100) | affected forest fraction (500) | affected forest fraction (1000) | affected forest fraction (2000) |
|--------------------|-------------------|--------------------------------|--------------------------------|---------------------------------|---------------------------------|
| Bergstraße         | 3074,74           | 2,5                            | 13,6                           | 27,3                            | 51,3                            |
| Heidelberg         | 458,62            | 0,6                            | 8,6                            | 27,8                            | 66,0                            |
| Mannheim           | 194,10            | 5,4                            | 25,6                           | 51,4                            | 91,1                            |
| Rhein-Neckar-Kreis | 4027,89           | 2,5                            | 13,4                           | 26,3                            | 48,1                            |

5.2

a) yes it does.

b) According to [this](https://outdoors.stackexchange.com/questions/16521/how-far-from-a-road-do-i-need-to-be-to-not-hear-the-traffic)
article, with just a point as sound source, the motorway sound would be indistinguishable from the forest background noise about 3.8km away from the motorway.

Reaching the entry of the forest, trees would reduce the advance of the sound waves.
Also air moisture and especially wind do have an effect on the sound propagation.

I think a buffer for affected forrest regions should be at least 2km (if i had to choose from the 4 given values).
But the outcome of this analysis should not be treated as a final result.

If one wanted to get the actually affected forest regions, a lot more factors should be considered.
