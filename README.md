
The **gdal transparent hillshades** makefile let you runs 4 tests for transparent hillshades.

### Run

Running the 4 tests :
```
make -f hillshade.mk LIMIT=170 INPUT=./input.tmp.tif
```

Running your favorite process and only it :
```
make -f hillshade.mk LIMIT=170 INPUT=./input.tmp.tif 4  # there are 4 processes : 1, 2, 3, 4
```
### Trick
Resizing to screensize proportionaly:
```
gdalwarp -of GTiff -ts 1280 0 input.tif output.tif
```  

### Dependencies
 * gdal
 * gdal_calc

### Resources
You can download further GIS rasters via on-demand area selection on http://gdex.cr.usgs.gov/gdex/. We recommand you to download : GTOPO30 (1px=1km) for area 1000km wide or over ; *NASA SRTM 3 arsec* (1px=90m) for area about 100km wide ; *NASA SRTM 1 arsec* (1px=90m) for area 25km wide.