## Installing the plug-in

The plug-in works with DPC++ and Open SYCL, so you can choose to install either
or both depending on your needs by following
[these](install_compiler.md) instructions.

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

## Using the plug-in: building the tutorial

If at any point you wish to clean leftovers from previous builds, you can
simply run:

`./build.sh clean` or `./build.sh realclean`

And to build the tutorial or probe the build system:

`./build.sh compiler gpu_arch [amrex_make_opts]`

- `compiler` is either `dpcpp` (also `dpc++`) or `opensycl` (also `hipsycl`);
- `gpu_arch` is an architecture or compute capability specification, for
example:
    - `sm_70` for the Nvidia V100 or `sm_80` for the Nvidia A100;
    - `gfx908` for the AMD MI100 or `gfx90a` for the AMD MI200 series;

    see the
    [Nvidia developer pages](https://developer.nvidia.com/cuda-gpus)
    or the
    [ROCm installation guide](https://docs.amd.com/bundle/ROCm-Installation-Guide-v5.4.3/page/Prerequisites.html#d5434e299)
    for other Nvidia or AMD GPUs, respectively;
- `amrex_make_opts` is any valid variable or command listed in
[AMReX's documentation](https://amrex-codes.github.io/amrex/docs_html/BuildingAMReX.html).

To learn more about how `build.sh` works, see this
[supporting document](details_plugin.md).

### Examples

To build the tutorial for the Nvidia A100 using DPC++ with six parallel jobs:

`./build.sh dpcpp sm_80 -j6`

To print the compiler flags for Open SYCL and the AMD MI200 series:

`./build.sh opensycl gfx90a print-CXXFLAGS`

## Executing the tutorial

To run the tutorial, simply do:

`./main3d.sycl.TPROF.ex inputs`
