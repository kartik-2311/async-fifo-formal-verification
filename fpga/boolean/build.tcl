set root [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $root .. ..]]
set output [file join $project_root results boolean]
if {[file exists $output]} {error "Existing build preserved; use a fresh checkout for another implementation"}
file mkdir $output
cd $output
set_param general.maxThreads 2
create_project -in_memory -part xc7s50csga324-1
read_verilog -sv [list [file join $project_root async_fifo.sv] [file join $root fifo_smoke.sv] [file join $root boolean_fifo_top.sv]]
read_xdc [file join $root boolean_fifo.xdc]
synth_design -top boolean_fifo_top -part xc7s50csga324-1 -flatten_hierarchy none
set sync_regs [get_cells -hier -regexp {.*u_fifo/u_sync_(wr2rd|rd2wr)/(meta_ff_reg|sync_ff_reg).*}]
if {[llength $sync_regs] != 20} {error "Expected 20 FIFO synchronizer registers; got [llength $sync_regs]"}
set_property ASYNC_REG TRUE $sync_regs
set_property SHREG_EXTRACT NO $sync_regs
foreach dir {wr2rd rd2wr} {
    set dst [get_cells -hier -filter "NAME =~ demo/u_fifo/u_sync_$dir/meta_ff_reg*"]
    set d [get_pins -of_objects $dst -filter {REF_PIN_NAME == D}]
    set starts [all_fanin -flat -startpoints_only -to $d]
    set src [get_cells -of_objects $starts]
    if {[llength $dst] != 5 || [llength $src] != 5} {error "Incomplete Gray-bus endpoint coverage for $dir"}
    # MMCM clocks stay related. RAM and ordinary logic stay setup/hold timed.
    # First-stage Gray inputs are intentional CDC captures: bound their data
    # propagation/skew without a broad inter-clock false path or clock group.
    set_bus_skew 10.0 -from $src -to $dst
    set_max_delay -datapath_only 10.0 -from $src -to $dst
    puts "GRAY_ENDPOINTS $dir [llength $dst]"
}
opt_design
place_design
route_design
report_clocks -file [file join $output clocks.rpt]
report_clock_interaction -file [file join $output clock_interaction.rpt]
report_timing_summary -report_unconstrained -file [file join $output timing.rpt]
report_bus_skew -file [file join $output bus_skew.rpt]
report_cdc -details -file [file join $output cdc.rpt]
report_methodology -file [file join $output methodology.rpt]
report_drc -file [file join $output drc.rpt]
report_utilization -file [file join $output utilization.rpt]
write_xdc -force [file join $output implemented_constraints.xdc]
write_checkpoint -force [file join $output routed.dcp]
set stream [open [file join $output timing.rpt] r]
set timing [read $stream]
close $stream
if {![string match {*All user specified timing constraints are met.*} $timing]} {
    error "Timing report does not confirm setup, hold and pulse-width closure"
}
if {![string match {*checking no_clock (0)*} $timing] || ![string match {*checking unconstrained_internal_endpoints (0)*} $timing]} {
    error "Unclocked or unconstrained internal endpoints need review"
}
foreach kind {max min} {
    set paths [get_timing_paths -delay_type $kind -max_paths 1]
    if {[llength $paths] == 0} {error "No $kind timing paths; cannot accept an empty report"}
    set slack [get_property SLACK $paths]
    puts "CHECKED_SLACK $kind $slack"
    if {$slack < 0} {error "$kind timing failed: slack $slack"}
}
set drc [get_drc_violations -quiet -filter {SEVERITY == Error || SEVERITY == {Critical Warning}}]
if {[llength $drc]} {error "Implementation DRC has Error/Critical Warning violations: $drc"}
write_bitstream -force [file join $output boolean_fifo_top.bit]
puts "FIFO_BITSTREAM_BUILD_COMPLETE [file join $output boolean_fifo_top.bit]"
exit
