# A SYCL plug-in for AMReX's ElectromagneticPIC tutorial

[SYCL](https://www.khronos.org/sycl/) unlocks single-source development for
hardware accelerators by leveraging C++ templated functions, greatly easing the
otherwise laborious task of porting C++ code to heterogeneous architectures.
The aim of this work is to show that state of the art scientific applications
like [AMReX](https://amrex-codes.github.io) can be solely written in SYCL
while still preserving its performance portability features.

We demonstrate how minimal the required development effort can be with
[AMReX's ElectromagneticPIC tutorial](https://amrex-codes.github.io/amrex/tutorials_html/Particles_Tutorial.html#electromagneticpic)
due to its relevance to plasma fusion applications. We note, however, that all AMReX
applications should be able to benefit.
Here is an illustration of a PIC simulation you can carry out with this code:

![Plasma Oscillations](https://github.com/amrPX-Projects/empic-bench/blob/master/Langmuir.gif)

_Current-driven Langmuir oscillations at the plasma frequency obtained
on a 32 x 32 x 32 grid with 1 electron per cell. The mesh is coloured after the 
amplitude of the oscillating but uniform electric field: from blue (-) to red
(+)._

The plug-in consists of build scripts and code patches which extend
AMReX's SYCL capability beyond Intel GPUs.
As of this writing we support a couple of open-source SYCL compiler and runtime
frameworks:
- [DPC++](https://github.com/intel/llvm) (proprietary solutions, e.g. the
[Intel oneAPI DPC++/C++ Compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/dpc-compiler.html)
and its [plugins](https://codeplay.com/portal/blogs/2022/12/16/bringing-nvidia-and-amd-support-to-oneapi.html),
should also work);
- [Open SYCL](https://github.com/OpenSYCL/OpenSYCL)
(formerly known as hipSYCL).

The plug-in has been tested on _all_ the generally available high performance
computing GPUs, which at the beginning of 2023 means the following cards:

- AMD: MI100, MI210 and MI250;
- Nvidia: V100 and A100.

Since AMReX also includes native support for both the Nvidia CUDA and the AMD
HIP programming models, a direct comparison against those is trivial. We have
shown elsewhere that the SYCL implementation is at least as fast as those
vendor alternatives.

### Acknowledgments

- Joe Todd ([@joeatodd](https://github.com/joeatodd)),
Rod Burns ([@rodburns](https://github.com/rodburns)),
and the Codeplay developer team
([@codeplaysoftware](https://github.com/codeplaysoftware))
for helping to identify an issue with slow floating-point atomics on GPUs,
and for developing the AMD and Nvidia support plugins for DPC++;
- Aksel Alpay ([@illuhad](https://github.com/illuhad)),
and the Open SYCL developer team
([@opensycl](https://github.com/opensycl))
for cultivating a welcoming community,
for reviewing and suggesting improvements to our contributions to Open SYCL,
and for developing Open SYCL;
- Andrew Myers ([@atmyers](https://github.com/atmyers)),
Axel Huebl ([@ax3l](https://github.com/ax3l)),
Weiqun Zhang ([@weiqunzhang](https://github.com/weiqunzhang)),
and the AMReX developer team
([@amrex-codes](https://github.com/amrex-codes))
for welcoming and reviewing our contributions to AMReX and its tutorials,
and for developing AMReX;
- UKAEA ([@ukaea](https://github.com/ukaea)),
and the FARSCAPE project
([@farscape-project](https://github.com/farscape-project)) for funding this work.

## Installing a SYCL compiler and runtime framework

The plug-in works with DPC++ and Open SYCL, so you can choose to install either
or both depending on your needs. Whichever you choose, you will be using the
clang/LLVM toolchain to compile your application.
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

:hourglass_flowing_sand: For the impatient, there is a collection of
incantations that usually work at the
[bottom of this document](#hourglass-quick-instructions-to-install-a-sycl-compiler-and-runtime-framework).

## Installing the plug-in

Get AMReX and its tutorials in a directory of your choice:

```
git clone https://github.com/AMReX-Codes/amrex
git clone https://github.com/AMReX-Codes/amrex-tutorials
```

Copy the contents of this repository and place them alongside the source files
of the ElectromagneticPIC tutorial:

```
git clone url_of_this_repository
cp -r empic-bench/SYCL amrex-tutorials/ExampleCodes/Particles/ElectromagneticPIC/Exec
```

If you wish to use an existing AMReX installation, set the `AMREX_HOME`
environment variable or change its value at the top of `build.sh` to point to
the desired location.

## Building the tutorial

If at any point you wish to clean leftovers from previous builds, you can
simply run:

`./build.sh clean` or `./build.sh realclean`

And to build the tutorial or probe the build system:

`./build.sh compiler gpu_arch [amrex_make_opts]`

- `compiler` is either `dpcpp` (also `dpc++`) or `opensycl` (also `hipsycl`);
- `gpu_arch` is an architecture or compute capability specification, for
example:
    - `gfx908` for the AMD MI100 or `gfx90a` for the AMD MI200 series;
    - `sm_70` for the Nvidia V100 or `sm_80` for the Nvidia A100;

    see the
    [ROCm installation guide](https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.4.3/page/Prerequisites.html#d5434e299)
    or the
    [Nvidia developer pages](https://developer.nvidia.com/cuda-gpus) for other
    AMD or Nvidia GPUs, respectively;
- `amrex_make_opts` is any valid variable or command as listed in
[AMReX's documentation](https://amrex-codes.github.io/amrex/docs_html/BuildingAMReX.html).

### Examples

To build the tutorial for the Nvidia A100 using DPC++ with six parallel jobs:

`./build.sh dpcpp sm_80 -j6`

To print the compiler flags for the AMD MI200 series if using Open SYCL:

`./build.sh opensycl gfx90a print-CXXFLAGS` 

## How does the plug-in work?

As the reader might have guessed and as a quick inspection of `build.sh` will
reveal, the script is no more than a wrapper around the `GNUmakefile` already
provided with the ElectromagneticPIC tutorial.
The makefile reuses the source code from the CUDA version of the tutorial
(there really is no CUDA, just generic code that gets versioned by AMReX's
conditional compilation flow) and leverages AMReX's existing SYCL compilation
flow by setting `USE_SYCL = TRUE`.

`build.sh` does a handful of alterations to AMReX and its build system, it:
- switches AMReX's compiler to `clang++` or `syclcc` for DPC++ or Open SYCL,
respectively;
- overwrites the compiler flags to use the appropriate settings depending on
the selected compiler, the target vendor assembly/source language, i.e.
AMDGCN/HIP or NVPTX/CUDA, and the target architecture;
- provides AMReX the right sub-group size (also known as wavefront or warp size
by AMD and Nvidia, respectively) depending on the target vendor;
- patches AMReX to avoid missing declarations and SYCL 2020 features
[Open SYCL only];
- patches AMReX to disable managed memory [AMD GPUs only].

## Executing the tutorial

To run the benchmark, simply do:

`./main3d.sycl.TPROF.ex inputs`

## :hourglass: Quick instructions to install a SYCL compiler and runtime framework

If you are feeling lucky, try to configure, build and install your compiler and
runtime framework as follows. These lines are meant to be executed from within
the respective source directories.

### DPC++

AMD GPUs
```
python ./buildbot/configure.py --hip --cmake-opt="-DSYCL_BUILD_PI_HIP_ROCM_DIR=/path/to/rocm" -o /path/to/install/dir
python ./buildbot/compile.py -o /path/to/install/dir
```

Nvidia GPUs
```
python ./buildbot/configure.py --cuda --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=/path/to/cuda" -o /path/to/install/dir
python ./buildbot/compile.py -o /path/to/install/dir
```

### LLVM
```
cmake -S llvm -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS=clang -DLLVM_BUILD_LLVM_DYLIB=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```

### Open SYCL

AMD GPUs
```
cmake -S . -B build -DLLVM_ROOT=/path/to/llvm/lib/cmake -DBOOST_ROOT=/path/to/boost -DROCM_PATH=/path/to/rocm -DWITH_ROCM_BACKEND=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```

Nvidia GPUs
```
cmake -S . -B build -DLLVM_ROOT=/path/to/llvm/lib/cmake -DBOOST_ROOT=/path/to/boost -DCUDA_TOOLKIT_ROOT_DIR=/path/to/cuda -DWITH_CUDA_BACKEND=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DCMAKE_INSTALL_PREFIX=/path/to/install/dir
cmake --build build
cmake --build build -- install
```
