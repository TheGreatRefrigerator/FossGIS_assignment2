ogr2ogr -t_srs EPSG:32632 forest_UTM.geojson forest.geojson
ogr2ogr -t_srs EPSG:32632 highways_UTM.geojson highways.geojson
ogr2ogr -where "NAME_2 IN ('Heidelberg','Bergstraße','Rhein-Neckar-Kreis','Mannheim')" -t_srs EPSG:32632 gadm36_DEU_shp/selected.shp gadm36_DEU_shp/gadm36_DEU_2.shp
