from codar.cheetah import parameters as p


def create_experiment(writer_nprocs, reader_nprocs, configFile, scalingType, adios_xml_file, writer_decomposition, reader_decomposition, machine_name, node_layout, marshal, transport, lock, post_hoc=False):
    """
    Creates a sweep object that tells Cheetah how to run the adios io test.
    Assumes 1D decomposition.
    """

    params = [
            p.ParamRunner('writer', 'nprocs', [writer_nprocs]),
            p.ParamRunner('reader', 'nprocs', [reader_nprocs]),
    
            p.ParamCmdLineOption('writer', 'appid', '-a', [1]),
            p.ParamCmdLineOption('writer', 'configFile','-c', [configFile]),
            p.ParamCmdLineOption('writer', 'scaling', scalingType, [None]),
            p.ParamCmdLineOption('writer', 'adios_xml_file', '-x', [adios_xml_file]),
            p.ParamCmdLineOption('writer', 'decomposition','-d',[writer_decomposition]),
#            p.ParamCmdLineOption('writer', 'timing_info','-t',[None]),
            p.ParamADIOS2XML('writer', 'transport', 'io_T1', 'engine', [ {"SST": {'MarshalMethod':marshal, "DataTransport": transport}}]),
            p.ParamCmdLineOption('reader', 'appid', '-a', [2]),
            p.ParamCmdLineOption('reader', 'configFile','-c', [configFile]),
            p.ParamCmdLineOption('reader', 'scaling', scalingType, [None]),
            p.ParamCmdLineOption('reader', 'adios_xml_file', '-x', [adios_xml_file]),
            p.ParamCmdLineOption('reader', 'decomposition','-d',[reader_decomposition]),
            p.ParamADIOS2XML('reader', 'transport', 'io_T2_in', 'engine', [ {"SST": {"DataTransport":transport, "SpeculativePreloadMode": "Off"}} ]),
#            p.ParamCmdLineOption('reader', 'timing_info','-t',[None]),
            ]

    if lock:
        params.append(p.ParamCmdLineOption('writer', "lock spec", '-F', [None]))
        params.append(p.ParamCmdLineOption('reader', "lock spec", '-F', [None]))
    rc_dependency = None
    if post_hoc:
        rc_dependency = {'reader': 'writer'}

    sweep = p.Sweep(parameters=params, rc_dependency=rc_dependency)
    if node_layout:
        sweep.node_layout = {machine_name: node_layout}

    return sweep

