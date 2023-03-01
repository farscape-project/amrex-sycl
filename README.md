# A SYCL plug-in for AMReX's ElectromagneticPIC tutorial

The plug-in consists of build scripts and code patches which extend
[AMReX](https://amrex-codes.github.io)'s SYCL capability beyond Intel GPUs.
As of this writing we support a couple of open-source SYCL compiler and runtime
frameworks:
- [DPC++](https://github.com/intel/llvm) (proprietary solutions, e.g. the
[Intel oneAPI DPC++/C++ Compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/dpc-compiler.html)
and its [plugins](https://codeplay.com/portal/blogs/2022/12/16/bringing-nvidia-and-amd-support-to-oneapi.html),
should also work)
- [Open SYCL](https://github.com/OpenSYCL/OpenSYCL) (formerly known as hipSYCL)

The plug-in has been tested on _all_ the generally available high performance
computing GPUs, which at the beginning of 2023 means the following cards:

- AMD: MI100, MI210 and MI250
- Nvidia: V100 and A100

Since AMReX also includes native support for both the Nvidia CUDA and the AMD
HIP programming models, a direct comparison against those is trivial. We have
shown elsewhere that the SYCL implementation is at least as fast as those
vendor alternatives.

## Installing a SYCL compiler and runtime framework

The plug-in works with DPC++ and Open SYCL, so you can choose to install either
or both depending on your needs.
In order to use DPC++, you need only install... [TODO]()

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

If you wish to use an existing AMReX installation, set the environment variable
`AMREX_HOME` or change its value at the top of `build.sh` to point to the
desired location.

## Building the tutorial

If at any point you wish to clean leftovers from previous builds, you can
simply run:

`./build.sh clean` or `./build.sh realclean`

And to build the tutorial or probe the build system:

`./build.sh compiler gpu_arch [amrex_make_opts]`

- `compiler` is either `dpcpp` (also `dpc++`) or `opensycl` (also `hipsycl`)
- `gpu_arch` is an architecture or compute capability specification, for
example:
    - `gfx908` for the AMD MI100 or `gfx90a` for the AMD MI200 series
    - `sm_70` for the Nvidia V100 or `sm_80` for the Nvidia A100

    See the
    [ROCm installation guide](https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.4.3/page/Prerequisites.html#d5434e299)
    or the
    [Nvidia developer pages](https://developer.nvidia.com/cuda-gpus) for other
    AMD or Nvidia GPUs, respectively.
- `amrex_make_opts` is any valid variable or command as listed in
[AMReX's documentation](https://amrex-codes.github.io/amrex/docs_html/BuildingAMReX.html)

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
- Switches AMReX's compiler to `clang++` or `syclcc` for DPC++ or Open SYCL,
respectively
- Overwrites the compiler flags to use the appropriate settings depending on
the compiler you selected, the target vendor assembly/source language, i.e.
PTX/CUDA or AMDGCN/HIP, and the target architecture
- Patches AMReX to avoid some missing declarations and SYCL 2020 features
[Open SYCL only]
- Patches AMReX to disable managed memory and to use the same wavefront size
as AMReX's HIP compilation flow [AMD GPUs only]

## Executing the tutorial

To run the benchmark, simply do:

`./main3d.sycl.TPROF.ex inputs`
