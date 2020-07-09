# Synthetic SST campaign to test differing reader-side behaviour in BP
vs FFS marshaling.  FFS always fetches whole blocks, everything a
particular writer has written, even when only a portion of it might be
needed.  BP marshalling however fetches needed data individually, on a
per variable basis.  The question is how much does that impact
performance.  Presumably the FFS behaviour is better if all or most of
the data a particular writer has written is to be used by a reader
fetching any of it, because it minimizes request counts.  BUT, recent
changes that fully pipeline the request/response protocol might
mitigate this impact, and it might not matter at all with an RDMA data
transport (where the bulk of the cost might be writer-side mapping).
DataPreload (currently available only with the WAN transport), might
also have an impact here.

## To run Cheetah:

cheetah create-campaign -a \<path-to-exe-and-input-files\> -e \<path to spec file\> -m summit -o \<where to create campaign on gpfs\>

Once the campaign is created, you will see path-to-campaign/your-username/ . Either run `run-all.sh` here to launch all jobs, or cd into one of the directories and launch `submit.sh`.


## Monitoring a campaign:

cheetah status \<campaign path\> options
-n for summary

## Generate a performance report:

cheetah generate-report \<campaign path\>

## Execution Plan

All tests done with 200 small-array variables to maximize any impact.

Modes: BP FFS
       WAN RDMA
       LockGeometry NoPreload
       2x1   32x1       

Nodes (5):
  co-location: 8 (test), 512, 1024, 2048, 4096
  separate:    8+4,  512+256, 1024+512, 2048+1024,

Processes:
  co-location:  32 writer + 16 or 4 readers per node
  separate:     32 writer per node, 32 readers per node
  8 nodes:
     co-location:  256 writers    128/32 readers
     separate:     256 writers    128/32 readers
  512 nodes:
     co-location:  16384 writers  8192/2048 readers
     separate:     16384 writers  8192/2048 readers
  1024 nodes:
     co-location:  32768 writers  16384/4096 readers
     separate:     32768 writers  16384/4096 readers
  2048 nodes:
     co-location:  65536 writers  32768/8192 readers
     separate:     65536 writers  32768/8192 readers
  4096 nodes:
     co-location:  131072 writers  65536/16384 readers

