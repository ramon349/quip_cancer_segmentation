#!/bin/bash

source ./common_settings.sh

function cleanup() {
  docker stop ${container_name} || (echo "${container_name} not existing or running ...")
  docker rm -f -v ${container_name}|| (echo "${container_name} not existing or running ...")
  docker ps |grep ${container_name}
}

cleanup 

#mkdir data
#mkdir data/svs data/patches data/log data/heatmap_txt data/training_data
# the actual module should have 
#mkdir data
#mkdir data/svs data/patches data/log data/heatmap_txt data/training_data
#make a directory called data that has svs,output and log folders 
docker run -d --name ${container_name} \
--shm-size=8G \
-v `pwd`/data/:/quip_app/quip_cancer_segmentation/data/ \
-t ${public_docker_host}/${GOOGLE_PROJECT_ID}/${image_name}:${image_tag} 
sleep 2
docker ps

echo "enter container"
docker exec -it $container_name /bin/bash

##Sample usage:
##	docker run -v /home/myhomedir:/tmp vips:latest run_convert_wsi.sh /tmp/001738-000050_01_01_20180710.vsi /tmp/big.tif /tmp/multi.tif