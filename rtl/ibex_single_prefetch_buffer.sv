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

  logic mid_transaction_branch_req; //Indicates a branch request, i.e. a branch_i pulse, was receive while we're in the middle of an instruction fetch transaction.
  logic transaction_ongoing_reg; //Indicates a transaction is ongoing, that is instr_req_o has been raised, and the responding instr_rvalid/err_i has not been received yet.
  logic instr_req_reg;  //Registering the instr_req_o signal, in case the bus is stalled.
  logic [31:0] instr_adr_reg; //Register keeping track of the address of the instruction being fetched.
  logic rvalid_pending_reg; //rvalid pending register, used when IF-stage is not ready yet to receive the return data.
  logic err_pending_reg;  //err pending register, used when IF-stage is not ready yet to receive the error.
  logic [31:0] rdata_reg; //Registering the return data, in case the instruction fetch (IF) stage, is not ready.
  logic [31:0] addr_o_reg; //Register the instruction address, going along with the return data, in case the instruction fetch (IF) stage, is not ready.

  initial begin
    mid_transaction_branch_req = 1'b0;
    instr_req_reg = 1'b0;
    instr_adr_reg = 0;
    transaction_ongoing_reg = 1'b0;
    rvalid_pending_reg = 1'b0;
    err_pending_reg = 1'b0;
    rdata_reg = 0;
    addr_o_reg = 0;
  end

  always_comb begin
    //If we're currently not handling a transaction
    if (!transaction_ongoing_reg) begin
      //Was there a mid-transaction branch request in the previous transaction?
      if (mid_transaction_branch_req) begin //Yes, then start a new transaction using the branch address.
        instr_req_o  = req_i;
        instr_addr_o = instr_adr_reg;
      end else begin  //No pending branch request.
        /* Put new core transactions on the bus right away...*/
        instr_req_o  = req_i;
        /* Use the input address if it's a branch request. Use the previous address + 4 if not, i.e. if it's linear instruction fetching.
         * Note that the + 4 assumes all instructions are 4 bytes in size, i.e. there are no compressed instructions.*/
        instr_addr_o = branch_i ? addr_i : addr_o + 4;
      end
    end else begin  //A transaction is ongoing...
      /* Extend the asserted signals using their registered counterparts in case the bus is stalled. */
      instr_req_o  = instr_req_reg;
      instr_addr_o = instr_adr_reg;
    end
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      mid_transaction_branch_req <= 1'b0;
      instr_req_reg <= 1'b0;
      instr_adr_reg <= 0;
      transaction_ongoing_reg <= 1'b0;
      rdata_reg <= 0;
      addr_o_reg <= 0;
      rvalid_pending_reg <= 1'b0;
      err_pending_reg <= 1'b0;
    end else begin
      //If we're currently not handling a transaction
      if (!transaction_ongoing_reg) begin
        if (mid_transaction_branch_req) begin
          mid_transaction_branch_req <= 1'b0; //Reset the mid-transaction branch request as soon as we start servicing it.
        end
        if (instr_req_o) begin //If this signal is asserted, we have started a new transaction and we're waiting for a grant.
          transaction_ongoing_reg <= 1'b1;
          instr_req_reg <= instr_req_o & ~instr_gnt_i; //If a grant is received (this may happen during same cycle on which instr_req_o is asserted), instr_req_o is cleared on the next cycle.
          instr_adr_reg <= instr_addr_o; //Keep track of the address. instr_addr_o is only valid when instr_req_o is asserted.
        end
      end else begin  //A transaction is ongoing...
        if (req_i && branch_i) begin
          //A Branch request arrives mid-transaction. Hang on to it until we can issue a new transaction.
          mid_transaction_branch_req <= 1'b1;
          instr_adr_reg <= addr_i;
        end
        if (instr_gnt_i) begin  //A grant is received.
          instr_req_reg <= 1'b0;  //Clear instr_rq_o on the next cycle.
        end
        //If we have pending return date or error, and the IF stage is finally ready.
        if ((rvalid_pending_reg || err_pending_reg) && ready_i) begin
          transaction_ongoing_reg <= 1'b0;  //We can end this transaction.
          rvalid_pending_reg <= 1'b0;
          err_pending_reg <= 1'b0;
        end else if (instr_rvalid_i || instr_err_i) begin  //Return data or error received from bus.
          addr_o_reg <= instr_adr_reg;
          rdata_reg  <= instr_rdata_i;

          if (!ready_i) begin
            rvalid_pending_reg <= instr_rvalid_i & ~(mid_transaction_branch_req | branch_i);
            err_pending_reg <= instr_err_i & ~(mid_transaction_branch_req | branch_i);
          end

          //If we have an pending branch request, retire this transaction and
          //move on to the branch transaction.
          //If we don't have a pending branch request, retire the transaction if
          //the IF stage is ready. If the IF stage is not ready, we prolong the
          //transaction.
          transaction_ongoing_reg <= ~ready_i & ~(mid_transaction_branch_req | branch_i);
        end
      end
    end
  end

  assign addr_o = rvalid_pending_reg ? addr_o_reg : instr_adr_reg;
  assign rdata_o = rvalid_pending_reg ? rdata_reg : instr_rdata_i;
  //We don't return data or err to the IF-stage if it's not ready or if we
  //received a mid-transaction branch request.
  assign valid_o = (instr_rvalid_i | rvalid_pending_reg) & ready_i & ~(mid_transaction_branch_req | branch_i);
  assign err_o = (instr_err_i | err_pending_reg) & ready_i & ~(mid_transaction_branch_req | branch_i);
  assign err_plus2_o = 1'b0;  //A single transaction prefetcher can't have plus2 errors.

  // Prefetch Buffer Status
  assign busy_o = transaction_ongoing_reg;
endmodule
