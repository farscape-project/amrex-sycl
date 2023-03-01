: ${AMREX_HOME:=../../../../../../amrex}

COMP=$( tr '[A-Z]' '[a-z]' <<< $1)

###
### DPC++
###

if [[ $COMP == "dpcpp" || $COMP == "dpc++" ]]; then

CC=clang++
CXX=clang++

CXXFLAGS="-g1 -O3 -std=c++17 -pthread -fgpu-inline-threshold=100000 \
          -fsycl -Xclang -mlong-double-64"

if [[ $2 == "sm_"* ]]; then
    CXXFLAGS=$CXXFLAGS" -fsycl-targets=nvptx64-nvidia-cuda \
                        -Xsycl-target-backend --cuda-gpu-arch=$2"
elif [[ $2 == "gfx"* ]]; then
    CXXFLAGS=$CXXFLAGS" -fsycl-targets=amdgcn-amd-amdhsa \
                        -Xsycl-target-backend --offload-arch=$2"
fi

LDFLAGS="-fsycl-device-lib=libc,libm-fp32,libm-fp64"

###
### Open SYCL
###

elif [[ $COMP == "opensycl" || $COMP == "hipsycl" ]]; then

CC=syclcc
CXX=syclcc

CXXFLAGS="-g1 -O3 -std=c++17 -pthread -fgpu-inline-threshold=100000"

if [[ $2 == "sm_"* ]]; then
    CXXFLAGS=$CXXFLAGS" --hipsycl-targets=cuda:$2"
elif [[ $2 == "gfx"* ]]; then
    CXXFLAGS=$CXXFLAGS" --hipsycl-targets=hip:$2 -munsafe-fp-atomics"
fi

LDFLAGS=

###
### Unrecognised compiler
###

else
    echo "Error: Unrecognised compiler!" 1>&2
    exit 1
fi

if [[ $2 == "gfx"* ]]; then
    (cd "$AMREX_HOME" && patch -p0) < amd_amrex.patch
fi

make DEPFLAGS= CC="$CC" CXX="$CXX" CXXFLAGS="$CXXFLAGS" LDFLAGS="$LDFLAGS" "${@:3}"

if [[ $2 == "gfx"* ]]; then
    (cd "$AMREX_HOME" && patch -R -p0) < amd_amrex.patch
fi
