### SYCL/DPC++-on-CUDA implementation of the ElectromagneticPIC benchmark

#### Building

To build the benchmark, probe the build system or clean leftovers from previous
builds, do _not_ directly invoke GNU Make, instead do:

`./build.sh [make-options]`

For example:

`./build.sh -j6` or
`./build.sh print-CXXFLAGS` or
`./build.sh clean` or
`./build.sh realclean`

As the reader might have guessed and as a quick inspection of `build.sh` will
reveal, the script is no more than a wrapper around `GNUMakefile`.
The makefile reuses the source code for the CUDA version of the benchmark
(there really is no CUDA, just generic code that gets versioned by AMReX's
conditional compilation flow) and leverages AMReX's DPC++ build settings by
using `USE_DPCPP = TRUE`.

Since AMReX is expecting the production-ready Intel oneAPI DPC++/C++ Compiler
which does not have a CUDA backend, a compatible compiler must instead be used.
As of this writing we support [intel/llvm](https://github.com/intel/llvm) and
[hipSYCL](https://github.com/illuhad/hipSYCL).

For hipSYCL we are currently trying to build support for using nvc++, since
early testing suggests clang cannot produce a binary with competitive
performance. Since nvc++ follows the single-source single compiler pass (SSCP)
model and not the single-source multiple compiler pass (SMCP) model which AMReX
is expecting, leveraging nvc++ requires deeper code changes.
In fact, AMReX uses macros such as `AMREX_DEVICE_COMPILE` and
`__SYCL_DEVICE_ONLY__` to detect if the device is being targeted thereby
breaking the SSCP model.

`build.sh` changes the default compiler to `clang++` or `syclcc` for
intel/llvm and hipSYCL respectively, overwrites the compiler flags to change
the target for SYCL builds to CUDA and patches AMReX to use the same warp size
for SYCL/DPC++ as it does for CUDA.

Note that `build.sh` expects this benchmark to be placed inside its respective
directory in [amrex-tutorials](https://github.com/AMReX-Codes/amrex-tutorials)
which should be placed alongside [amrex](https://github.com/AMReX-Codes/amrex).
Change `AMREX_HOME` in `build.sh` to point to a different location if this is
not the case.

#### Executing

To run the benchmark, simply do:

`./main3d.dpcpp.TPROF.ex inputs`
