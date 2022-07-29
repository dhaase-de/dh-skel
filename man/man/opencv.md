# OpenCV #


## Building from Source ##


### Workflow ###

Tested with OpenCV 3.2.0.

Required libraries: `cmake cmake-curses-gui`

1. Install required libraries

        aptitude install cmake cmake-curses-gui

2. Download source from https://github.com/opencv/opencv/releases
3. Create build dir

        mkdir build && cd build
        
4. Run `cmake` (alternatively the GUI `ccmake`)

        cmake -DBUILD_DOCS=off -DBUILD_EXAMPLES=on -DBUILD_TESTS=on -DBUILD_PERF_TESTS=on -DBUILD_opencv_python2=off -DINSTALL_C_EXAMPLES=on -DINSTALL_TESTS=on -DWITH_MATLAB=off -DCMAKE_INSTALL_PREFIX=./install -Dopencv_dnn_BUILD_TORCH_IMPORTER=off ..

5. Start build