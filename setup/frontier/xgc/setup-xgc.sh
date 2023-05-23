module reset
module unload perftools-base
module load cmake
module load PrgEnv-amd
module swap amd amd/5.2.0
module swap cray-mpich cray-mpich/8.1.23
module load craype-accel-amd-gfx90a
