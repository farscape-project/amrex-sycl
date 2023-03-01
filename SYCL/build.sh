: ${AMREX_HOME:=../../../../../../amrex}

if [[ $1 == clean || $1 == realclean ]]; then
    COMP=dpcpp
    GPU_ARCH=none
    AMREX_MAKE_OPTS=$1
else
    COMP=$( tr '[A-Z]' '[a-z]' <<< $1)
    GPU_ARCH=$2
    AMREX_MAKE_OPTS=${@:3}
fi

###
### DPC++
###

if [[ $COMP == dpcpp || $COMP == dpc++ ]]; then

CC=clang++
CXX=clang++

CXXFLAGS="-g1 -O3 -std=c++17 -pthread -fgpu-inline-threshold=100000 \
          -fsycl -Xclang -mlong-double-64"

if [[ $GPU_ARCH == sm_* ]]; then
    CXXFLAGS=$CXXFLAGS" -fsycl-targets=nvptx64-nvidia-cuda \
                        -Xsycl-target-backend --cuda-gpu-arch=$GPU_ARCH"
elif [[ $GPU_ARCH == gfx* ]]; then
    CXXFLAGS=$CXXFLAGS" -fsycl-targets=amdgcn-amd-amdhsa \
                        -Xsycl-target-backend --offload-arch=$GPU_ARCH"
fi

LDFLAGS="-fsycl-device-lib=libc,libm-fp32,libm-fp64"

###
### Open SYCL
###

elif [[ $COMP == opensycl || $COMP == hipsycl ]]; then

CC=syclcc
CXX=syclcc

CXXFLAGS="-g1 -O3 -std=c++17 -pthread -fgpu-inline-threshold=100000"

if [[ $GPU_ARCH == sm_* ]]; then
    CXXFLAGS=$CXXFLAGS" --hipsycl-targets=cuda:$GPU_ARCH"
elif [[ $GPU_ARCH == gfx* ]]; then
    CXXFLAGS=$CXXFLAGS" --hipsycl-targets=hip:$GPU_ARCH -munsafe-fp-atomics"
fi

LDFLAGS=

###
### Unrecognised compiler
###

else
    echo "Error: Unrecognised compiler!" 1>&2
    exit 1
fi

if [[ $GPU_ARCH == gfx* ]]; then
    (cd "$AMREX_HOME" && patch -p0) < amd_amrex.patch
fi

make -f ../CUDA/GNUmakefile \
     Bpack="../CUDA/Make.package ../../Source/Make.package" \
     Blocs="../CUDA ../../Source" \
     USE_CUDA=FALSE \
     USE_HIP=FALSE \
     USE_SYCL=TRUE \
     USE_MPI=FALSE \
     BL_NO_FORT=TRUE \
     DEPFLAGS= \
     CC="$CC" \
     CXX="$CXX" \
     CXXFLAGS="$CXXFLAGS" \
     LDFLAGS="$LDFLAGS" \
     $AMREX_MAKE_OPTS

if [[ $GPU_ARCH == gfx* ]]; then
    (cd "$AMREX_HOME" && patch -R -p0) < amd_amrex.patch
fi
