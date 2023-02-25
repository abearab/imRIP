conda env create -f envs/radar.yml 

conda activate radar

Rscript -e "options(unzip = 'internal'); library(devtools); install_github('scottzijiezhang/RADAR')"

