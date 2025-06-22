// Copyright lowRISC contributors.
// Copyright 2018 ETH Zurich and University of Bologna, see also CREDITS.md.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`ifdef __ICARUS__
`timescale 1 ns / 1 ps
`endif

/**
 * BoxLambda: Single Instruction Prefetcher Buffer for 32 bit memory
 * interface. This module only works for non-compressed instructions.
 *
 * I attempted a no-prefetch version, but the branch_i protocol handling IRQs
 * expects to find a prefetched instruction waiting to figure out where to
 * returns to after servicing the IRQ.
 */
module ibex_single_prefetch_buffer (
    input logic clk_i,
    input logic rst_ni,

    input logic req_i,

    input logic        branch_i,
    input logic [31:0] addr_i,

    input  logic        ready_i,
    output logic        valid_o,
    output logic [31:0] rdata_o,
    output logic [31:0] addr_o,
    output logic        err_o,
    output logic        err_plus2_o,

    // goes to instruction memory / instruction cache
    output logic        instr_req_o,
    input  logic        instr_gnt_i,
    output logic [31:0] instr_addr_o,
    input  logic [31:0] instr_rdata_i,
    input  logic        instr_err_i,
    input  logic        instr_rvalid_i,

    // Prefetch Buffer Status
    output logic busy_o
);
  typedef enum logic [2:0] {
    START = 0,
    WAIT_FOR_GRANT = 1,
    WAIT_FOR_GRANT_BR_PENDING = 2,
    WAIT_FOR_VALID = 3,
    WAIT_FOR_VALID_BR_PENDING = 4,
    WAIT_FOR_READY = 5
  } state_type_t;

  state_type_t state_reg, state_next;
  logic [31:0] instr_addr_reg, instr_addr_next;
  logic [31:0] br_pending_addr_reg, br_pending_addr_next;
  logic [31:0] instr_rdata_reg, instr_rdata_next;
  logic instr_err_reg, instr_err_next;
  logic instr_rvalid_reg, instr_rvalid_next;

  initial begin
    state_reg = START;
    instr_addr_reg = 32'b0;
    br_pending_addr_reg = 32'b0;
    instr_rdata_reg = 32'b0;
    instr_err_reg = 1'b0;
    instr_rvalid_reg = 1'b0;
  end

  always_comb begin
    state_next = state_reg;
    instr_addr_next = instr_addr_reg;
    br_pending_addr_next = br_pending_addr_reg;
    instr_rdata_next = instr_rdata_reg;
    instr_err_next = instr_err_reg;
    instr_rvalid_next = instr_rvalid_reg;

    instr_req_o = 1'b0;
    instr_addr_o = instr_addr_reg;
    valid_o = 1'b0;
    err_o = 1'b0;
    rdata_o = instr_rdata_reg;

    case (state_reg)
      START: begin
        instr_req_o = req_i;

        if (req_i) begin
          if (branch_i) begin
            instr_addr_o = addr_i;
            instr_addr_next = addr_i;
          end

          if (instr_gnt_i) state_next = WAIT_FOR_VALID;
          else state_next = WAIT_FOR_GRANT;
        end
      end
      WAIT_FOR_GRANT: begin
        instr_req_o = 1'b1;

        case ({
          branch_i, instr_gnt_i
        })
          2'b01: begin
            state_next = WAIT_FOR_VALID;
          end
          2'b10: begin
            br_pending_addr_next = addr_i;
            state_next = WAIT_FOR_GRANT_BR_PENDING;
          end
          2'b11: begin
            br_pending_addr_next = addr_i;
            state_next = WAIT_FOR_VALID_BR_PENDING;
          end
          default: ;
        endcase
      end
      WAIT_FOR_GRANT_BR_PENDING: begin
        instr_req_o = 1'b1;

        if (instr_gnt_i) state_next = WAIT_FOR_VALID_BR_PENDING;
      end
      WAIT_FOR_VALID: begin
        casez ({
          ready_i, branch_i, instr_rvalid_i | instr_err_i
        })
          3'b001: begin
            instr_rdata_next = instr_rdata_i;
            instr_err_next = instr_err_i;
            instr_rvalid_next = instr_rvalid_i;
            state_next = WAIT_FOR_READY;
          end
          3'b?10: begin
            br_pending_addr_next = addr_i;
            state_next = WAIT_FOR_VALID_BR_PENDING;
          end
          3'b?11: begin
            instr_addr_next = addr_i;
            state_next = WAIT_FOR_GRANT;
          end
          3'b101: begin
            valid_o = instr_rvalid_i;
            err_o = instr_err_i;
            rdata_o = instr_rdata_i;
            instr_addr_next = instr_addr_reg + 4;
            state_next = START;
          end
          default: ;
        endcase
      end
      WAIT_FOR_VALID_BR_PENDING: begin
        if (instr_rvalid_i) begin
          instr_addr_next = br_pending_addr_reg;
          state_next = WAIT_FOR_GRANT;
        end
      end
      WAIT_FOR_READY: begin
        if (branch_i) begin
          instr_addr_next = addr_i;
          state_next = WAIT_FOR_GRANT;
        end else if (ready_i) begin
          valid_o = instr_rvalid_reg;
          err_o = instr_err_reg;
          rdata_o = instr_rdata_reg;
          instr_addr_next = instr_addr_reg + 4;
          state_next = START;
        end
      end
      default: ;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_reg <= START;
      instr_addr_reg <= 32'b0;
      br_pending_addr_reg <= 32'b0;
      instr_rdata_reg <= 32'b0;
      instr_err_reg <= 1'b0;
      instr_rvalid_reg <= 1'b0;
    end else begin
      state_reg <= state_next;
      instr_addr_reg <= instr_addr_next;
      br_pending_addr_reg <= br_pending_addr_next;
      instr_rdata_reg <= instr_rdata_next;
      instr_err_reg <= instr_err_next;
      instr_rvalid_reg <= instr_rvalid_next;
    end
  end

  assign addr_o = instr_addr_reg;
  assign busy_o = (state_reg == START) ? 1'b0 : 1'b1;
  assign err_plus2_o = 1'b0;
endmodule
