#/bin/bash 
for i in "$@"
do
case $i in
    -imageInput=*)
    imageInput="${i#*=}"
    shift # past argument=value
    ;;
    -originalInput=*)
    originalInput="${i#*=}"
    shift # past argument=value
    ;;
    -result=*)
    result="${i#*=}"
    shift # past argument=value
    ;;
    -BORBcompatible=*)
    BORBcompatible="${i#*=}"
    shift
    ;;
    -CNN_MODEL=*)
    CNN_MODEL="${i#*=}"
    shift
    ;;
    *)
          # unknown option
    ;;
esac
done 
echo "Received imageInput=$imageInput"
echo "Received originalInput=$originalInput"
if [ -s "$imageInput" ]
then
     echo "imageInput=$imageInput from converter is not empty, use it"
else
     echo "imageInput=$imageInput from converter is empty, use originalInput=$originalInput"
     imageInput=${originalInput}
fi

export CNN_MODEL
echo "using:${CNN_MODEL} for segmentation}"
#define paths 
main_dir="/quip_app/quip_cancer_segmentation"
data_dir="${main_dir}/data"
svs_dir="${data_dir}/svs"
output_dir="${data_dir}/output"
patch_dir="${data_dir}/patches"
log_dir="$output_dir/log"
#initialize directories 
mkdir -p ${svs_dir}
mkdir -p ${output_dir}
mkdir -p ${patch_dir}
mkdir -p ${log_dir}

#extract  tar or zip file if necessary
mkdir -p /tmp/data
mv $imageInput /tmp/data/ 
cd /tmp/data 
tar xzvf ./*.tar.gz
unzip ./*.zip
#move images to svs dir 
echo "Moving ${imageInput} contents to svs folder"
cp *.{svs,tiff,tif} ${svs_dir}



cd /root
#call heatmap extraction code  
cd "${main_dir}/scripts/"
bash ./svs_2_heatmap.sh 
useBorb=`echo ${BORBcompatible} | awk '{print tolower($0)}' `
echo "BORB VARIABLE HAS ${useBorb}"
if [ ["$useBorb"=="true"] ]
then 
     echo "Starting conversion"
     bash ./borbConv.sh
fi  
cd ${data_dir}
tar -czf /cromwell_root/${result} ./output
ls -alt /cromwell_root/${result}