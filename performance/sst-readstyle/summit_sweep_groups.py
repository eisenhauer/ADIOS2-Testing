from sweep_groups_helper import create_sweep_groups
from summit_node_layouts import summit_node_layouts


# Parameters
writer_np               = [32, 512]
reader_np_ratio         = [1,8]
writers_per_node_summit = [32]
marshal			= ['ffs', 'bp']
transport		= ['WAN', 'RDMA']
lock			= [1, 0]
size_per_pe             = ['2x1','8x1']
run_repetitions         = 0
batch_job_timeout_secs  = 3600
per_experiment_timeout  = 600


node_layouts = summit_node_layouts('writer', 'reader')

sweep_groups = create_sweep_groups ('summit',
                                    writer_np,
                                    reader_np_ratio,
                                    size_per_pe,
                                    marshal,
                                    transport,
                                    lock,
                                    run_repetitions,
                                    batch_job_timeout_secs,
                                    node_layouts,
                                    per_experiment_timeout)

