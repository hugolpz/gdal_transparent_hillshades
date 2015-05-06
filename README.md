
The **gdal transparent hillshades** makefile let you download and run 3 tests for transparent GIS hillshades. This is a complement to ["How to create transparent hillshade?"](http://gis.stackexchange.com/questions/144535/how-to-get-transparent-hillshade/144700#144700), where more details is given.

### Run

Running the 3 tests :
```
make -f hillshade.mk LIMIT=170 INPUT=./input.tmp.tif
```

Run your favorite process and only it :
```
make -f hillshade.mk LIMIT=200 INPUT=./input.tmp.tif 2 
```
### Trick
Resizing to screensize (width=1280px), proportionaly:
```
gdalwarp -of GTiff -ts 1280 0 input.tif output.tif
```

### Dependencies
 * gdal
 * gdal_calc

### Resources
You can download further GIS rasters via on-demand area selection on http://gdex.cr.usgs.gov/gdex/. We recommand you to use and download :
 * *GTOPO30* (1px=1km) for area 1000km wide or over ; 
 * *NASA SRTM 3 arsec* (1px=93m) for area about 100km wide ; 
 * *NASA SRTM 1 arsec* (1px=31m) for area 25km wide.

### License
*  Lopez Hugo (@hugo_lz), MIT License / CC-by-sa-4.0 (pick your license).

![Opaque hillshade](http://i.stack.imgur.com/1uobu.png "Opaque hillshade")
![Transparent hillshade](http://i.stack.imgur.com/bdVNL.png "Transparent hillshade")