# please set your project account
export proj=phy122

# required dependencies
module load cmake/3.22.2
module load craype-accel-amd-gfx90a
module load rocm/5.1.0
module load cray-mpich
module load cce/14.0.1  # must be loaded after rocm

# optional: faster builds
module load ccache
module load ninja

# optional: just an additional text editor
module load nano

# optional: for PSATD in RZ geometry support (not yet available)
#module load cray-libsci_acc/22.06.1.2
#module load blaspp
#module load lapackpp

# optional: for QED lookup table generation support
module load boost/1.79.0-cxx17

# optional: for openPMD support
#module load adios2/2.7.1
module load cray-hdf5-parallel/1.12.2.1
export ADIOS2_ROOT=/ccs/proj/e2e/pnorbert/ADIOS/ADIOS2/build.frontier.2.9.cray/install

# optional: for Python bindings or libEnsemble
module load cray-python/3.9.12.1

# fix system defaults: do not escape $ with a \ on tab completion
shopt -s direxpand

# make output group-readable by default
umask 0027

# an alias to request an interactive batch node for one hour
#   for paralle execution, start on the batch node: srun <command>
alias getNode="salloc -A $proj -J warpx -t 01:00:00 -p batch -N 1 --ntasks-per-node=8 --gpus-per-task=1 --gpu-bind=closest"
# an alias to run a command on a batch node for up to 30min
#   usage: runNode <command>
alias runNode="srun -A $proj -J warpx -t 00:30:00 -p batch -N 1 --ntasks-per-node=8 --gpus-per-task=1 --gpu-bind=closest"

# GPU-aware MPI
export MPICH_GPU_SUPPORT_ENABLED=1

# optimize CUDA compilation for MI250X
export AMREX_AMD_ARCH=gfx90a

# compiler environment hints
export CC=$(which cc)
export CXX=$(which CC)
export FC=$(which ftn)
export CFLAGS="-I${ROCM_PATH}/include"
export CXXFLAGS="-I${ROCM_PATH}/include -Wno-pass-failed"
export LDFLAGS="-L${ROCM_PATH}/lib -lamdhip64"
