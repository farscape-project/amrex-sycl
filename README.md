# A SYCL plug-in to run AMReX apps on AMD/Nvidia GPUs

_**Nuno Nobre**, Alex Grant, Karthikeyan Chockalingam and Xiaohu Guo_

[![DOI](https://zenodo.org/badge/650097643.svg)](https://zenodo.org/badge/latestdoi/650097643)
###

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

![Plasma Oscillations](https://github.com/amrPX-Projects/empic-bench/blob/master/doc/fig/Langmuir.gif)

_Current-driven Langmuir oscillations at the plasma frequency on a
32 x 32 x 32 grid with 1 electron per cell. The mesh is coloured after the
amplitude of the oscillating but uniform electric field: from blue (-) to red
(+)._

The plug-in consists of a build script and code patches which extend
AMReX's SYCL capability beyond Intel GPUs.
We support two open-source SYCL compiler and runtime frameworks:
- [DPC++](https://github.com/intel/llvm) (proprietary solutions, e.g. the
[Intel oneAPI DPC++/C++ Compiler](https://www.intel.com/content/www/us/en/developer/tools/oneapi/dpc-compiler.html)
and its [plugins](https://codeplay.com/solutions/oneapi/), should also work);
- [Open SYCL](https://github.com/OpenSYCL/OpenSYCL)
(formerly known as hipSYCL).

The plug-in has been tested on _all_ the high performance computing GPUs
generally available at the beginning of 2023:

- Nvidia: V100 and A100;
- AMD: MI100, MI210 and MI250.

Since AMReX also includes native support for both the Nvidia CUDA and the AMD
HIP programming models, a direct comparison against those is trivial. This plot
shows that the SYCL implementation is as fast as those vendor alternatives.

![Performance Results](https://github.com/amrPX-Projects/empic-bench/blob/master/doc/fig/Performance.png)

_SYCL vs CUDA and HIP. Performance comparison for a Langmuir oscillations
simulation on a 128 x 128 x 128 grid with 64 electrons per cell and 100 time
steps. The PIC loop is always faster on the SYCL implementation, but the
particle initialisation routine is notably slower, meaning the small number of
iterations results in slower execution times for SYCL on some GPUs such as the
A100. For a detailed per-routine comparison for each GPU, see
[here](doc/fig/PerformancePerRoutine.pdf)._

To learn how to install and use the plug-in, continue reading
[here](doc/use_plugin.md).

## Acknowledgments

- Joe Todd ([@joeatodd](https://github.com/joeatodd)),
Rod Burns ([@rodburns](https://github.com/rodburns)),
and the Codeplay developer team
([@codeplaysoftware](https://github.com/codeplaysoftware))
for helping to identify an issue with slow floating-point atomics on GPUs,
and for developing the Nvidia and AMD support plugins for DPC++;
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
