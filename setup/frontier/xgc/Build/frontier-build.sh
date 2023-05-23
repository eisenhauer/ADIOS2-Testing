source ../frontier-setup.sh

find ./ -mindepth 1 -maxdepth 1 -not -name "setup.sh" -and -not -name "build.sh" -exec rm -r {} \+
cmake \
	-DCMAKE_CXX_COMPILER=${CRAY_MPICH_PREFIX}/bin/mpicxx \
	-DCMAKE_C_COMPILER=${CRAY_MPICH_PREFIX}/bin/mpicc \
	-DCMAKE_Fortran_COMPILER=${CRAY_MPICH_PREFIX}/bin/mpifort \
	-DPRINT_COPA_ARTIFACTS=ON \
	/ccs/proj/e2e/pnorbert/XGC-Devel
make -j 16

#prefix=/ccs/home/esuchyta/software/install/frontier/xgc-amd5.2-master
#if [ ! -e "$prefix" ]; then
#	ln -s $(pwd) $prefix
#fi
