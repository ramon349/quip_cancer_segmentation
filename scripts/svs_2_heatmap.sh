#!/bin/bash

echo "running enviroment set up"
cd ../
source ./conf/variables.sh

out_folders="heatmap_jsons heatmap_txt json log patch-level-color patch-level-lym patch-level-merged patch-level-nec"
for i in ${out_folders}; do
	if [ ! -d ${OUT_DIR}/$i ]; then
		mkdir -p ${OUT_DIR}/$i
	fi
done
if [ ! -d ${DATA_DIR}/patches ]; then
	mkdir -p ${DATA_DIR}/patches;
fi
wait;

echo "Staring patch extraction"
cd patch_extraction_cancer_40X
nohup bash start.sh &
cd ..

echo "Done with patch extraction"
echo "Starting prediction on patches"
cd prediction
nohup bash start.sh &
cd ..
echo "Done with prediction on patches"
wait;

echo "Starting heatmap generation"
cd heatmap_gen
nohup bash start.sh &
cd ..
echo "Starting heatmap generation"

echo "Done: We now move to converting to borb "
wait;

exit 0
