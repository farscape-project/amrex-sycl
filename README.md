# A SYCL plug-in for AMReX's ElectromagneticPIC tutorial
_**Nuno Nobre**, Alex Grant, Karthikeyan Chockalingam and Xiaohu Guo_

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

To learn how to install and use the plug-in, continue reading
[here](doc/use_plugin.md).

## Acknowledgments

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
