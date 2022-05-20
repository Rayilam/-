# setting Synthesis options
set_property strategy {Vivado Synthesis defaults} [get_runs synth_1]
# keep module port names in the netlist
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY {none} [get_runs synth_1]
		
# synthesizing user design
synth_design -top ${user_mod} -part ${device} -mode out_of_context

# setup output logs and reports
report_utilization -hierarchical -file ${synth_rpt_dir}/${user_mod}_util_hier.rpt
report_utilization -file ${synth_rpt_dir}/${user_mod}_util.rpt

write_checkpoint -force ${dcp_dir}/${user_mod}.dcp
