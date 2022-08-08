AMREX_HOME=../../../../../../amrex

CC=clang++
CXX=clang++

CXXFLAGS="-g1 -O3 -std=c++17 \
-Wno-pass-failed -Wno-tautological-constant-compare -Wno-error=sycl-strict \
-fsycl -fsycl-targets=nvptx64-nvidia-cuda -fsycl-device-code-split=per_kernel \
-mlong-double-64 -Xclang -mlong-double-64 -pthread"

CC=syclcc
CXX=syclcc

CXXFLAGS="-g1 -O3 -std=c++17 \
--hipsycl-targets=cuda:sm_70 \
-pthread"

USE_MPI=FALSE


(cd "$AMREX_HOME" && patch -p0) < amrex.patch

make CC="$CC" CXX="$CXX" CXXFLAGS="$CXXFLAGS" USE_MPI="$USE_MPI" "$@"

(cd "$AMREX_HOME" && patch -R -p0) < amrex.patch
