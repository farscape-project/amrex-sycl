## Installing a SYCL compiler and runtime framework

Whether you choose DPC++ or Open SYCL, you will be using the clang/LLVM
toolchain to compile your application.
In fact, DPC++ is Intel's fork of LLVM with compiler and runtime support for
SYCL. Open SYCL is essentially a wrapper around vanilla LLVM.

In order to install DPC++, you should skim the
[DPC++ getting started guide](https://intel.github.io/llvm-docs/GetStartedGuide.html)
and follow the instructions for your desired target. Once the installation is
complete, add:
- `/path/to/install/dir/bin` to the `PATH` environment variable;
- `/path/to/install/dir/lib` to the `LD_LIBRARY_PATH` environment variable.

In order to install Open SYCL, please refer to the
[Open SYCL installation instructions](https://github.com/OpenSYCL/OpenSYCL/blob/develop/doc/installing.md).
Please note that if your system does not already provide an LLVM installation,
you first need one. Start by checking the Open SYCL
[recommendations](https://github.com/OpenSYCL/OpenSYCL/blob/develop/doc/install-llvm.md)
and the [LLVM installation instructions](https://llvm.org/docs/CMake.html).
Once the installation is
complete, add:
- `/path/to/install/dir/bin` to the `PATH` environment variable.

:hourglass_flowing_sand: For the impatient, the following is a collection of
incantations that usually work.

### Quick instructions on how to install a SYCL compiler and runtime framework

If you are feeling lucky, try to configure, build and install your compiler and
runtime framework as follows. These lines are meant to be executed from within
the respective source directories.

#### DPC++

Nvidia GPUs
```
python ./buildbot/configure.py --cuda --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=/path/to/cuda" -o /path/to/install/dir
python ./buildbot/compile.py -o /path/to/install/dir
```

AMD GPUs
```
python ./buildbot/configure.py --hip --cmake-opt="-DSYCL_BUILD_PI_HIP_ROCM_DIR=/path/to/rocm" -o /path/to/install/dir
python ./buildbot/compile.py -o /path/to/install/dir
```

#### LLVM
```
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -DLLVM_BUILD_LLVM_DYLIB=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```

#### Open SYCL

Nvidia GPUs
```
cmake -S . -B build -DLLVM_ROOT=/path/to/llvm/lib/cmake -DBOOST_ROOT=/path/to/boost -DCUDA_TOOLKIT_ROOT_DIR=/path/to/cuda -DWITH_CUDA_BACKEND=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```

AMD GPUs
```
cmake -S . -B build -DLLVM_ROOT=/path/to/llvm/lib/cmake -DBOOST_ROOT=/path/to/boost -DROCM_PATH=/path/to/rocm -DWITH_ROCM_BACKEND=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```
