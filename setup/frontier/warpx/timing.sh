$!/bin/bash

grep "total time" round*/n*/*/output.txt  | sed -e "s/round.\/n//" -e "s/\.1\/output.txt.*\.\.\.//" > timing.txt

