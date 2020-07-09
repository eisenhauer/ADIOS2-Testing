from sweep_groups_helper import create_sweep_groups


# Parameters
writer_np               = [2,4,8]
reader_np_ratio         = [2]
marshal			= ['ffs', 'bp']
transport		= ['WAN']
lock			= [1, 0]
size_per_pe             = ['2x1','8x1']
run_repetitions         = 0
batch_job_timeout_secs  = 3600
per_experiment_timeout  = 600


sweep_groups = create_sweep_groups ('local',
                                    writer_np,
                                    reader_np_ratio,
                                    size_per_pe,
                                    marshal,
                                    transport,
                                    lock,
                                    run_repetitions,
                                    batch_job_timeout_secs,
                                    None,
                                    per_experiment_timeout)

