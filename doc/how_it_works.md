## How does the plug-in work?

The build script, `build.sh`, is no more than a wrapper around the
`GNUmakefile` already provided with the CUDA version of the tutorial.
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
