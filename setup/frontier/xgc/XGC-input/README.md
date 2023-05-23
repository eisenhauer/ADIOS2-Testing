ITER case with `2 million` mesh elements for EM simulation (with kinetic electron)

- use `xgc-eem-cpp-gpu`;
- build with `DELTAF_CONV=ON`, and `MULTI_RATE=ON`;
- cases are setup to use driftkinetic ion and kinetic electron;
- On Summit, use the following settings:
  - 14 million ions and 14 million electrons per GPU;
  - a total of 480 GPUs, or 80 nodes on Summit;
  - 15 GPUs per poloidal plane;
  - this corresponds to roughly 105 ions or electrons per triangular element.
- This case used a smoothed background profiles:
  - Refer to folder "visualization_script/smoothed_background_profile" for details.

To run without multirate timestepping, use the following settings:
```
&mr_param
! multirate timestepping related parameters
mr_factor1=1
mr_factor2=1
mr_factor3=1
mr_factor4=1
mr_factor5=1
mr_psi_max1=0.1
mr_psi_max2=0.3
mr_psi_max3=0.5
mr_psi_max4=0.7
mr_psi_max5=0.9
/
```

To run with multirate timestepping, modify the `mr_*` related parameters in the
input file, for example:
```
&mr_param
! multirate timestepping related parameters
mr_factor1=15
mr_factor2=14
mr_factor3=13
mr_factor4=12
mr_factor5=11
mr_psi_max1=0.1
mr_psi_max2=0.3
mr_psi_max3=0.5
mr_psi_max4=0.7
mr_psi_max5=0.9
/
```
