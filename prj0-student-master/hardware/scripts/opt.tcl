# open shell checkpoint
open_checkpoint ${script_dir}/../shell/route_shell.dcp

# open role checkpoint
read_checkpoint -cell [get_cells mpsoc_i/role_cell/inst] ${script_dir}/../shell/synth_role.dcp
read_checkpoint -cell [get_cells mpsoc_i/role_cell/inst/${user_inst}] ${dcp_dir}/${user_mod}.dcp

# setup output logs and reports
report_timing_summary -file ${synth_rpt_dir}/${rpt_prefix}_timing.rpt -delay_type max -max_paths 20

# Design optimization
opt_design

