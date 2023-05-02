# A SYCL plug-in for AMReX's ElectromagneticPIC tutorial

[SYCL](https://www.khronos.org/sycl/) unlocks single-source development for
hardware accelerators by leveraging C++ templated functions, greatly easing the
otherwise laborious task of porting C++ code to heterogeneous architectures.
The aim of this work is to show that state of the art scientific applications
such as [AMReX](https://amrex-codes.github.io) can be solely written in SYCL
while still preserving its performance portability features.

We demonstrate how minimal the extra required development effort can be with
[AMReX's ElectromagneticPIC tutorial](https://amrex-codes.github.io/amrex/tutorials_html/Particles_Tutorial.html#electromagneticpic).
This is due to the tutorial's relevance to plasma fusion but we note that
all AMReX applications should be able to benefit.
Here is an illustration of a PIC simulation you can carry out using this code:

![Plasma Oscillations](https://github.com/amrPX-Projects/empic-bench/blob/master/doc/Langmuir.gif)

_Current-driven Langmuir oscillations at the plasma frequency on a
32 x 32 x 32 grid with 1 electron per cell. The mesh is coloured after the
amplitude of the oscillating but uniform electric field: from blue (-) to red
(+)._

The plug-in consists of a build script and code patches which extend
AMReX's SYCL capability beyond Intel GPUs.
We support two open-source SYCL compiler and runtime frameworks:
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
([@farscape-project](https://github.com/farscape-project))
for funding this work.

## Installing the plug-in

The plug-in works with DPC++ and Open SYCL, so you can choose to install either
or both depending on your needs by following [these](doc/install_compiler.md)
instructions.

Once you have a working compiler and runtime framework, get AMReX and its
tutorials in a directory of your choice:

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
- `amrex_make_opts` is any valid variable or command listed in
[AMReX's documentation](https://amrex-codes.github.io/amrex/docs_html/BuildingAMReX.html).

To learn more about how `build.sh` works, see this
[supporting document](doc/how_it_works.md).

### Examples

To build the tutorial for the Nvidia A100 using DPC++ with six parallel jobs:

`./build.sh dpcpp sm_80 -j6`

To print the compiler flags for Open SYCL and the AMD MI200 series:

`./build.sh opensycl gfx90a print-CXXFLAGS`

## Executing the tutorial

To run the tutorial, simply do:

`./main3d.sycl.TPROF.ex inputs`
