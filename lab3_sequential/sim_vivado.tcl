# Vivado Batch Simulation Script for Lab 3
# Usage: vivado -mode batch -source sim_vivado.tcl -tclargs prob1_dff

set prob [lindex $argv 0]
if {$prob eq ""} {
    puts "Usage: vivado -mode batch -source sim_vivado.tcl -tclargs <problem_dir>"
    exit 1
}

regexp {^prob\d+_(.*)} $prob -> mod

set proj_name "sim_${mod}"
set proj_dir "./${prob}/vivado_proj"

create_project $proj_name $proj_dir -part xc7a35tcpg236-1 -force
add_files -norecurse ./${prob}/${mod}.v
add_files -fileset sim_1 -norecurse ./${prob}/${mod}_tb.v
set_property top ${mod}_tb [get_filesets sim_1]

launch_simulation
run all
close_sim
close_project
