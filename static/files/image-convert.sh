#!/bin/bash
## TODO: Make an automated script to cnform images to the overall blog style
## Input: image
## Output: converted image (and make backup)
IMAGE=$1

convert $IMAGE -resize 716 "00_res_$IMAGE"
convert "00_res_$IMAGE" -bordercolor "#ffd7af" -border 2x2 "01_border_$IMAGE"

convert "01_border_$IMAGE" -modulate 50,100,100 "02_mod_$IMAGE" 
convert "02_mod_$IMAGE" -colorspace gray -fill "#ffd7af" -tint 110 "03_final_$IMAGE"

exit 0