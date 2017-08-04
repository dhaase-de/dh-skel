# Caffe #


## Building from Source ##


### Workflow ###

1. Install required libraries (see below)
2. Clone Caffe repository

        git clone https://github.com/BVLC/caffe

3. *(optional)* rename caffe folder with added version

        mv caffe caffe-$(cd caffe && git describe --tags)

4. Create `Makefile.config` (see below)
5. Create and run `make.sh`:

        #!/bin/bash

        # robust bash scripting
        set -o errexit
        set -o nounset

        # get absolute path of this script
        SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
        cd "$SCRIPT_DIR"

        # use max number of cores for the compilation
        CORE_COUNT=$(cat /proc/cpuinfo | grep processor | wc -l)

        # compile and test
        make -j$CORE_COUNT all
        make -j$CORE_COUNT test
        make -j$CORE_COUNT runtest
        make -j$CORE_COUNT distribute
        
6. Update environment variables (put this into `setenv.sh`)

        CAFFE_ROOT="$LIB_DIR/caffe"
        if [ -d "$CAFFE_ROOT" ]; then
            # bins, libraries, python module
            export LD_LIBRARY_PATH="$CAFFE_ROOT/distribute/lib:$LD_LIBRARY_PATH"
            export PATH="$CAFFE_ROOT/distribute/bin:$PATH"
            export PYTHONPATH="$CAFFE_ROOT/distribute/python:$PYTHONPATH"

            # for nvcaffe
            export LD_LIBRARY_PATH="/usr/local/cuda-8.0/targets/aarch64-linux/lib/stubs:$LD_LIBRARY_PATH"
        else
            unset CAFFE_ROOT
        fi


### Linux4Tegra 28.1 on NVIDIA Jetson TX2 ###

* CUDA, cuDNN, etc. are all pre-installed, no further action is neccessary
* instead of OpenCV 3, the **pre-installed OpenCV 2 for Linux4Tegra will be used** (no action neccessary)
* install required packages:

        sudo aptitude install libboost-all-dev libgflags-dev libgoogle-glog-dev libprotobuf-dev protobuf-compiler libatlas-base-dev  python3 python3-dev python3-numpy libhdf5-serial-dev liblmdb-dev libleveldb-dev libsnappy-dev python3-pip python3-skimage
        sudo pip3 install protobuf

* `Makefile.config`:

        USE_CUDNN := 1        
        CUDA_DIR := /usr/local/cuda
        CUDA_ARCH := -gencode arch=compute_62,code=sm_62 -gencode arch=compute_62,code=compute_62
        BLAS := atlas
        PYTHON_LIBRARIES := boost_python-py35 python3.5m
        PYTHON_INCLUDE := /usr/include/python3.5m /usr/lib/python3.5/dist-packages/numpy/core/include
        PYTHON_LIB := /usr/lib
        WITH_PYTHON_LAYER := 1
        INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial
        LIBRARY_DIRS := $(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/aarch64-linux-gnu /usr/lib/aarch64-linux-gnu/hdf5/serial /usr/local/cuda-8.0/targets/aarch64-linux/lib/stubs
        BUILD_DIR := build
        DISTRIBUTE_DIR := distribute
        TEST_GPUID := 0
        Q ?= @

* for `nvcaffe` (https://github.com/NVIDIA/caffe):

        cd /usr/local/cuda-8.0/targets/aarch64-linux/lib/stubs
        sudo ln -s libnvidia-ml.so libnvidia-ml.so.1
