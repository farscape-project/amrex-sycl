AMREX_HOME=../../../../../../amrex

###
### DPC++
###

CC=clang++
CXX=clang++

CXXFLAGS="-g1 -O3 -std=c++17 -pthread \
-fgpu-inline-threshold=100000 \
-fsycl -fsycl-targets=nvptx64-nvidia-cuda \
-Xsycl-target-backend --cuda-gpu-arch=sm_70 \
-Xclang -mlong-double-64"

LDFLAGS=-fsycl-device-lib=libc,libm-fp32,libm-fp64

###
### hipSYCL
###

CC=syclcc
CXX=syclcc

CXXFLAGS="-g1 -O3 -std=c++17 -pthread \
-fgpu-inline-threshold=100000 \
--hipsycl-targets=cuda:sm_70"

LDFLAGS=

USE_MPI=FALSE


(cd "$AMREX_HOME" && patch -p0) < amrex.patch

make DEPFLAGS= CC="$CC" CXX="$CXX" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" USE_MPI="$USE_MPI" "$@"

(cd "$AMREX_HOME" && patch -R -p0) < amrex.patch
