# make -f hillshades.mk LIMIT=170 INPUT=./input.tmp.tif : runs 4 tests for transparent hillshades
LIMIT=220
INPUT=./srtm3.tmp.tif

end: 1 2 3
	# just to them all.

1: opacity
	# COLOR: hillshade. OPACITY: 255-A (invert of color)
	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./opacity_linear.tmp.tif 	--calc="256-A" 
	gdalbuildvrt -separate ./final.vrt ./hillshade.tmp.tif ./opacity_linear.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif
	#
	gdal_translate -co ALPHA=YES ./final.vrt ./0_final_no_compression.tif

2: opacity
	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./$@_color_crop.tmp.tif		--calc="255*(A>$(LIMIT)) +      A*(A<=$(LIMIT))"
	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./$@_opacity_crop.tmp.tif	--calc="  1*(A>$(LIMIT)  +(256-A)*(A<=$(LIMIT))"
	gdalbuildvrt -separate ./final.vrt ./$@_color_crop.tmp.tif ./$@_opacity_crop.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final_crop.tif

3: opacity
	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./opacity_linear.tmp.tif 	--calc="256-A" 
	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./$@_color.tmp.tif			--calc="255*(A>$(LIMIT))+1*(A<=$(LIMIT))"
	gdalbuildvrt -separate ./final.vrt ./$@_color.tmp.tif ./opacity_linear.tmp.tif
	gdal_translate -co COMPRESS=LZW -co ALPHA=YES ./final.vrt ./$@_final.tif

opacity: shade
#	gdal_calc.py -A ./hillshade.tmp.tif  --outfile=./opacity_crop_transparency_up.tmp.tif --calc="256-( 255*(A>$(LIMIT)) + (255-$(LIMIT)+A)*(A<=$(LIMIT)) )"

shade:
	rm -f ./*.tif
	gdaldem hillshade $(INPUT) hillshade.tmp.tif -s 111120 -z 5 -az 315 -alt 60 -compute_edges