// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.1 (lin64) Build 2580384 Sat Jun 29 08:04:45 MDT 2019
// Date        : Mon Feb  1 16:14:07 2021
// Host        : liu-inspiron running 64-bit Ubuntu 20.04.1 LTS
// Command     : write_verilog -rename_top adder_reference -force adder_reference.v
// Design      : adder
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xczu2eg-sfva625-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* STRUCTURAL_NETLIST = "yes" *)
module adder_reference
   (operand0,
    operand1,
    result);
  input [7:0]operand0;
  input [7:0]operand1;
  output [7:0]result;

  wire [7:0]operand0;
  wire [7:0]operand1;
  wire [7:0]result;
  wire \result[4]_INST_0_i_1_n_0 ;
  wire \result[7]_INST_0_i_1_n_0 ;
  wire \result[7]_INST_0_i_2_n_0 ;

  LUT2 #(
    .INIT(4'h6)) 
    \result[0]_INST_0 
       (.I0(operand0[0]),
        .I1(operand1[0]),
        .O(result[0]));
  LUT4 #(
    .INIT(16'h8778)) 
    \result[1]_INST_0 
       (.I0(operand0[0]),
        .I1(operand1[0]),
        .I2(operand1[1]),
        .I3(operand0[1]),
        .O(result[1]));
  LUT6 #(
    .INIT(64'hF880077F077FF880)) 
    \result[2]_INST_0 
       (.I0(operand1[0]),
        .I1(operand0[0]),
        .I2(operand0[1]),
        .I3(operand1[1]),
        .I4(operand1[2]),
        .I5(operand0[2]),
        .O(result[2]));
  LUT3 #(
    .INIT(8'h96)) 
    \result[3]_INST_0 
       (.I0(\result[4]_INST_0_i_1_n_0 ),
        .I1(operand1[3]),
        .I2(operand0[3]),
        .O(result[3]));
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \result[4]_INST_0 
       (.I0(\result[4]_INST_0_i_1_n_0 ),
        .I1(operand0[3]),
        .I2(operand1[3]),
        .I3(operand1[4]),
        .I4(operand0[4]),
        .O(result[4]));
  LUT6 #(
    .INIT(64'hEEEEE888E8888888)) 
    \result[4]_INST_0_i_1 
       (.I0(operand1[2]),
        .I1(operand0[2]),
        .I2(operand1[0]),
        .I3(operand0[0]),
        .I4(operand0[1]),
        .I5(operand1[1]),
        .O(\result[4]_INST_0_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \result[5]_INST_0 
       (.I0(\result[7]_INST_0_i_1_n_0 ),
        .I1(operand1[5]),
        .I2(operand0[5]),
        .O(result[5]));
  LUT5 #(
    .INIT(32'hE81717E8)) 
    \result[6]_INST_0 
       (.I0(\result[7]_INST_0_i_1_n_0 ),
        .I1(operand0[5]),
        .I2(operand1[5]),
        .I3(operand1[6]),
        .I4(operand0[6]),
        .O(result[6]));
  LUT6 #(
    .INIT(64'h001717FFFFE8E800)) 
    \result[7]_INST_0 
       (.I0(operand1[5]),
        .I1(operand0[5]),
        .I2(\result[7]_INST_0_i_1_n_0 ),
        .I3(operand0[6]),
        .I4(operand1[6]),
        .I5(\result[7]_INST_0_i_2_n_0 ),
        .O(result[7]));
  LUT5 #(
    .INIT(32'hEEE8E888)) 
    \result[7]_INST_0_i_1 
       (.I0(operand1[4]),
        .I1(operand0[4]),
        .I2(\result[4]_INST_0_i_1_n_0 ),
        .I3(operand0[3]),
        .I4(operand1[3]),
        .O(\result[7]_INST_0_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \result[7]_INST_0_i_2 
       (.I0(operand0[7]),
        .I1(operand1[7]),
        .O(\result[7]_INST_0_i_2_n_0 ));
endmodule
