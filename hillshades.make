# make -f hillshade.mk LIMIT=170 INPUT=./input.tmp.tif : runs tests for transparent hillshades
# hillshade's px=221 (#DDDDDD = [221,221,221]) are flat areas.
# hillshade's px=221 divides the images between in shadow (A<221) and in light (A>221).
LIMIT=220
INPUT=./input.tmp.tif

end: 1 2 3 4
	# just to them all.

1: opacity
	# COLOR: hillshade. OPACITY: 255-A (invert of color)
	gdalbuildvrt -separate ./final.vrt ./shadedrelief.tmp.tif ./opacity_linear.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif
	gdal_translate -co ALPHA=YES ./final.vrt ./0_final.tif

2: opacity
	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./$@_color.tmp.tif 			--calc="255*(A>$(LIMIT))+A*(A<=$(LIMIT))"
	gdalbuildvrt -separate ./final.vrt ./$@_color.tmp.tif ./opacity_linear.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif

3: opacity
	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./$@_color.tmp.tif			--calc="255*(A>$(LIMIT))+1*(A<=$(LIMIT))"
	gdalbuildvrt -separate ./final.vrt ./$@_color.tmp.tif ./opacity_linear.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif

4: opacity
	# 4_color = 2_color
	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./$@_color.tmp.tif 			--calc="255*(A>$(LIMIT))+A*(A<=$(LIMIT))"
	gdalbuildvrt -separate ./final.vrt ./$@_color.tmp.tif ./opacity_crop.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif

opacity: shade
	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./opacity_linear.tmp.tif 	--calc="256-A" 
	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./opacity_crop.tmp.tif --calc="256-( 255*(A>$(LIMIT)) + A*(A<=$(LIMIT)) )"
#	gdal_calc.py -A ./shadedrelief.tmp.tif  --outfile=./opacity_crop_transparency_up.tmp.tif --calc="256-( 255*(A>$(LIMIT)) + (255-$(LIMIT)+A)*(A<=$(LIMIT)) )"

shade:
	rm -f ./*.tif
	gdaldem hillshade $(INPUT) shadedrelief.tmp.tif -s 111120 -z 5 -az 315 -alt 60 -compute_edges