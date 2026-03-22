# Vivado Batch Simulation Script for Lab 4
# Usage: vivado -mode batch -source sim_vivado.tcl -tclargs <problem_dir>
# Example: vivado -mode batch -source sim_vivado.tcl -tclargs prob1

set prob [lindex $argv 0]
if {$prob eq ""} {
    puts "Usage: vivado -mode batch -source sim_vivado.tcl -tclargs <problem_dir>"
    exit 1
}

# Per-problem configuration
array set top_modules {
    prob1 alu_acc_tb
    prob2 top_mux_dec_reg_tb
    prob3 datapath_tb
    prob4 good_counter_tb
}

set top $top_modules($prob)
set proj_name "sim_${prob}"
set proj_dir "./${prob}/vivado_proj"

create_project $proj_name $proj_dir -part xc7a35tcpg236-1 -force

# Add all .v files in the problem directory
foreach f [glob ./${prob}/*.v] {
    set fname [file tail $f]
    if {[string match "*_tb.v" $fname]} {
        add_files -fileset sim_1 -norecurse $f
    } else {
        add_files -norecurse $f
    }
}

set_property top $top [get_filesets sim_1]

launch_simulation
run all
close_sim
close_project
