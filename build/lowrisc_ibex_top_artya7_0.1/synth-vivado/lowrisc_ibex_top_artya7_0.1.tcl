# Auto-generated project tcl file


create_project lowrisc_ibex_top_artya7_0.1 -force

set_property part xc7a35ticsg324-1L [current_project]


set_property generic {SRAMInitFile=../../../../../examples/sw/led/led.vmem } [get_filesets sources_1]

set_property verilog_define {FPGA_XILINX=1 PRIM_DEFAULT_IMPL=prim_pkg::ImplXilinx } [get_filesets sources_1]
read_verilog -sv {../src/lowrisc_ibex_ibex_pkg_0.1/rtl/ibex_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_prim_pkg_0.1/prim_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_cipher_pkg_0.1/rtl/prim_cipher_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_generic_buf_0/rtl/prim_generic_buf.sv}
read_verilog -sv {../src/lowrisc_prim_generic_clock_gating_0/rtl/prim_generic_clock_gating.sv}
read_verilog -sv {../src/lowrisc_prim_generic_flop_0/rtl/prim_generic_flop.sv}
read_verilog -sv {../src/lowrisc_prim_ram_1p_pkg_0/rtl/prim_ram_1p_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_ram_2p_pkg_0/rtl/prim_ram_2p_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_22_16_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_22_16_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_28_22_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_28_22_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_39_32_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_39_32_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_64_57_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_64_57_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_72_64_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_72_64_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_22_16_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_22_16_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_39_32_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_39_32_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_72_64_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_72_64_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_76_68_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_hamming_76_68_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_22_16_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_22_16_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_28_22_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_28_22_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_39_32_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_39_32_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_64_57_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_64_57_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_72_64_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_72_64_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_22_16_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_22_16_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_39_32_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_39_32_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_72_64_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_72_64_enc.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_76_68_dec.sv}
read_verilog -sv {../src/lowrisc_prim_secded_0.1/rtl/prim_secded_inv_hamming_76_68_enc.sv}
read_verilog -sv {../src/lowrisc_prim_util_0.1/rtl/prim_util_pkg.sv}
read_verilog -sv {../src/lowrisc_prim_xilinx_buf_0/rtl/prim_xilinx_buf.sv}
read_verilog -sv {../src/lowrisc_prim_xilinx_clock_gating_0/rtl/prim_xilinx_clock_gating.sv}
read_verilog -sv {../src/lowrisc_prim_xilinx_clock_mux2_0/rtl/prim_xilinx_clock_mux2.sv}
read_verilog -sv {../src/lowrisc_prim_xilinx_flop_0/rtl/prim_xilinx_flop.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_icache_0.1/rtl/ibex_icache.sv}
read_verilog -sv {../src/lowrisc_prim_cipher_0/rtl/prim_subst_perm.sv}
read_verilog -sv {../src/lowrisc_prim_cipher_0/rtl/prim_present.sv}
read_verilog -sv {../src/lowrisc_prim_cipher_0/rtl/prim_prince.sv}
read_verilog -sv {../src/lowrisc_prim_generic_clock_mux2_0/rtl/prim_generic_clock_mux2.sv}
read_verilog -sv {../src/lowrisc_prim_generic_ram_1p_0/rtl/prim_generic_ram_1p.sv}
read_verilog -sv {../src/lowrisc_prim_generic_ram_2p_0/rtl/prim_generic_ram_2p.sv}
read_verilog -sv {../src/lowrisc_prim_lfsr_0.1/rtl/prim_lfsr.sv}
read_verilog -sv {../src/lowrisc_prim_onehot_check_0/rtl/prim_onehot_check.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_buf_0/prim_buf.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_clock_gating_0/prim_clock_gating.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_clock_mux2_0/prim_clock_mux2.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_flop_0/prim_flop.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_ram_2p_0/prim_ram_2p.sv}
read_verilog -sv {../src/lowrisc_prim_badbit_ram_1p_0/prim_badbit_ram_1p.sv}
read_verilog -sv {../src/lowrisc_prim_abstract_ram_1p_0/prim_ram_1p.sv}
read_verilog -sv {../src/lowrisc_ibex_fpga_xilinx_shared_0/rtl/fpga/xilinx/clkgen_xil7series.sv}
read_verilog -sv {../src/lowrisc_ibex_fpga_xilinx_shared_0/rtl/ram_2p.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_alu.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_branch_predict.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_compressed_decoder.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_controller.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_cs_registers.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_csr.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_counter.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_decoder.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_ex_block.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_fetch_fifo.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_id_stage.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_if_stage.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_load_store_unit.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_multdiv_fast.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_multdiv_slow.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_prefetch_buffer.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_pmp.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_wb_stage.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_dummy_instr.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_core_0.1/rtl/ibex_core.sv}
read_verilog -sv {../src/lowrisc_prim_ram_1p_adv_0.1/rtl/prim_ram_1p_adv.sv}
read_verilog -sv {../src/lowrisc_prim_ram_1p_scr_0.1/rtl/prim_ram_1p_scr.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_top_0.1/rtl/ibex_register_file_ff.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_top_0.1/rtl/ibex_register_file_fpga.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_top_0.1/rtl/ibex_register_file_latch.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_top_0.1/rtl/ibex_lockstep.sv}
read_verilog -sv {../src/lowrisc_ibex_ibex_top_0.1/rtl/ibex_top.sv}
read_verilog -sv {../src/lowrisc_ibex_top_artya7_0.1/rtl/top_artya7.sv}
read_xdc {../src/lowrisc_ibex_top_artya7_0.1/data/pins_artya7.xdc}
source {../src/lowrisc_ibex_top_artya7_0.1/util/vivado_setup_hooks.tcl}

set_property include_dirs [list ../src/lowrisc_dv_dv_fcov_macros_0 ../src/lowrisc_prim_assert_0.1/rtl ../src/lowrisc_prim_util_get_scramble_params_0/rtl ../src/lowrisc_prim_util_memload_0/rtl ../src/lowrisc_ibex_ibex_core_0.1/rtl .] [get_filesets sources_1]
set_property top top_artya7 [current_fileset]
set_property source_mgmt_mode None [current_project]


