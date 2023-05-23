module reset
module unload perftools-base
module load cmake
module load PrgEnv-amd
module swap amd amd/5.2.0
module swap cray-mpich cray-mpich/8.1.23
module load craype-accel-amd-gfx90a

export ROCM_PATH=/opt/rocm-5.2.0
export OLCF_ROCM_ROOT=${ROCM_PATH}
export CRAYPE_LINK_TYPE=dynamic
export PATH=${CRAY_MPICH_PREFIX}/bin:${PATH}
export PATH=${ROCM_COMPILER_PATH}/bin:${PATH}
export MPICH_CXX=`which hipcc`

export XGC_PLATFORM=frontier


# These don't matter for building, but I'm going to keep them here for reference


# GPU-aware MPI
#export MPIR_CVAR_GPU_EAGER_DEVICE_MEM=0     # On the Crusher page in the XGC docs
#export MPICH_GPU_SUPPORT_ENABLED=1          # Generally needed by Crusher/Frontier
#export MPICH_SMP_SINGLE_COPY_MODE=NONE      # Something to do with turning off on-node optimizations
    
# Some kind of Frontier debug flags
#export FI_MR_CACHE_MONITOR=memhooks
#export FI_CXI_RX_MATCH_MODE=software
