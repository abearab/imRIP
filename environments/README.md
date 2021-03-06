[RADAR manual](https://scottzijiezhang.github.io/RADARmanual/) is not working properly to install it while using conda! Therefore, I followed another way to setup an stable conda environment to use this package. 

source: [10.1186/s13059-019-1915-9](http://dx.doi.org/10.1186/s13059-019-1915-9)

However, you can simply use [this `yml` file](https://github.com/abearab/imRIP/blob/main/environments/radar.yml) to build an stable environment:
```bash
conda env create -f radar.yml
```
Then, just open R (in terminal or in Jupyter) and install [RADAR github](https://github.com/scottzijiezhang/RADAR). 
```R
library(devtools)
install_github("scottzijiezhang/RADAR") # or install('/local-path/RADAR')
```
**NOTE:** When it asks to update packages within R just select `None`. 

If `install_github` function doesn’t work, you can download the [RADAR github](https://github.com/scottzijiezhang/RADAR) as zip file. Then, you should unzip that file and use its path to run `install` functino in R. 

___
Now you can open a jupyter notebook to load RADAR in R. 
```bash
%load_ext rpy2.ipython
```
Then, use magic R to load it. 
```bash
%%R 
library("RADAR")
```
All set! 


<!-- 
## 1. Create new environment
As part of **imRIP** pipeline, let's use prefix to locate conda environments together. 
```bash
conda create -n radar
conda activate radar
```
## 2. install dependencies

> **Note:** There is no need to install jupyter multiple times! You can [install Jupyter](https://anaconda.org/anaconda/jupyter) in the base conda environment only once; then, you need to install `nb_conda_kernels` ([link](https://anaconda.org/conda-forge/nb_conda_kernels)) to launch Jupyter kernels for any installed conda environment. Also, you need `ipykernel`, `numpy` and `pandas` from `anaconda` channel in each environment; therefore, you see a kernel named after the conda environment which is ready to activate and use through opened notebook.

These three install commands contain packages required to install RADAR and use it within Jupyter notebook.
```bash
conda install -c bioconda \
bioconductor-genomicfeatures=1.34 \
bioconductor-rsamtools=1.34 \
bioconductor-deseq2=1.22 \
bioconductor-qvalue=2.14.1

conda install -c r \
r-bh r-doparallel r-foreach r-gplots \
r-ggplot2 r-rcolorbrewer r-rcpparmadillo \
r-tidyverse

conda install -c conda-forge r-rcpp r-devtools 

conda install -c anaconda \
ipykernel numpy pandas \
pip libgfortran
```
We need `rpy2` to use R with Python. To my experience, `pip` works robustly to intall it. 
```bash
pip install rpy2
```
(make sure through `which pip` that you run correct pip)
-->
