#
# CMAKE configuration script for WarpX to build with ADIOS2
#

#
# See https://warpx.readthedocs.io/en/latest/install/hpc/frontier.html
#
if [ "$0" == "-bash" ]; then
    SCRIPTDIR=/ccs/proj/e2e/pnorbert/warpx
else
    SCRIPTDIR=`dirname $0`
fi
echo "scriptdir=[${SCRIPTDIR}]"

source ${SCRIPTDIR}/frontier_warpx_profile.sh
cmake -DWarpX_COMPUTE=HIP \
      -DCMAKE_PREFIX_PATH="${ADIOS2_ROOT}" \
      -DWarpX_amrex_src=$SCRIPTDIR/src/amrex \
      -DWarpX_picsar_src=$SCRIPTDIR/src/picsar \
      -DWarpX_openpmd_src=$SCRIPTDIR/src/openPMD-api \
      ${SCRIPTDIR}/src/WarpX 
