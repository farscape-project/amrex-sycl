AMREX_HOME=../../../../../../amrex

###
### DPC++
###

CC=clang++
CXX=clang++

CXXFLAGS="-g1 -O3 -std=c++17 \
-Wno-pass-failed -Wno-tautological-constant-compare -Wno-error=sycl-strict \
-fsycl -fsycl-targets=nvptx64-nvidia-cuda -fsycl-device-code-split=per_kernel \
-fgpu-inline-threshold=100000 \
-Xsycl-target-backend --cuda-gpu-arch=sm_50 \
-mlong-double-64 -Xclang -mlong-double-64 -pthread"

LDFLAGS=-fsycl-device-lib=libc,libm-fp32,libm-fp64

###
### hipSYCL
###

CC=syclcc
CXX=syclcc

CXXFLAGS="-O3 -std=c++17 \
--hipsycl-targets=cuda-nvcxx \
-pthread"

LDFLAGS=

USE_MPI=FALSE


(cd "$AMREX_HOME" && patch -p0) < amrex.patch

make DEPFLAGS= CC="$CC" CXX="$CXX" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" USE_MPI="$USE_MPI" "$@"

(cd "$AMREX_HOME" && patch -R -p0) < amrex.patch
