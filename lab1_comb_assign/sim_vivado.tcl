# Vivado Batch Simulation Script for Lab 1
# Usage: vivado -mode batch -source sim_vivado.tcl -tclargs prob1_halfadder
#
# Or run individual problems:
#   vivado -mode batch -source sim_vivado.tcl -tclargs prob3_alu8bit

set prob [lindex $argv 0]
if {$prob eq ""} {
    puts "Usage: vivado -mode batch -source sim_vivado.tcl -tclargs <problem_dir>"
    puts "Example: vivado -mode batch -source sim_vivado.tcl -tclargs prob1_halfadder"
    exit 1
}

# Extract module name (strip probN_ prefix)
regexp {^prob\d+_(.*)} $prob -> mod

set proj_name "sim_${mod}"
set proj_dir "./${prob}/vivado_proj"

# Create project
create_project $proj_name $proj_dir -part xc7a35tcpg236-1 -force

# Add sources
add_files -norecurse ./${prob}/${mod}.v
add_files -fileset sim_1 -norecurse ./${prob}/${mod}_tb.v
set_property top ${mod}_tb [get_filesets sim_1]

# Run simulation
launch_simulation
run all
close_sim

# Cleanup
close_project
