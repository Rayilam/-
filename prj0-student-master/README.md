Project #0 (prj0) in Experiments of Computer Organization and Design (COD) in UCAS
=====
<changyisong@ict.ac.cn>
-----

## Hardware Design

### RTL Design

Please finish your RTL coding for adder first 
by editing *adder.v* in the directory of 
*hardware/sources/ip_catalog* according to 
the functional requirement in lecture slides.  

### Vivado FPGA Project

If not specified, Vivado toolset is launched in batch mode in this project 
as default. 

Please note that all make commands are launched in the top-level 
directory of your local repository.

1. Using `make HW_ACT=rtl_chk vivado_prj`  
to check syntax and synthesizability of your RTL source code. 
Please carefully modify and optimize your RTL code according to 
all errors and warnings you would meet in this step. 

2. If there are no errors occurring in Step 1, 
please use `make HW_ACT=sch_gen vivado_prj`  
to re-launch RTL checking in Vivado GUI mode and 
generate RTL schematics of your module adder.v.  
The generated schematics in PDF version are located 
in the directory of *hardware/vivado_out/rtl_chk*. 
You can check the generated schematics via a PDF viewer.  

3. Executing `make HW_ACT=bhv_sim vivado_prj`  
to run behavioral simulation for your RTL module. 

4. After simulation, please use  
`make HW_ACT=wav_chk vivado_prj`  
to check the waveform of behavioral simulation in Vivado GUI mode. 
You can change (add or remove signals to be observed) 
the waveform configuration file (.wcfg) and save it under Vivado GUI 
when running this step. 
If you want to observe the modified waveform, please re-launch 
behavioral simulation (Step 3) and waveform checking (Step 4). 
If you modify your RTL code to fix logical problems, 
please return back to Step 2 first.  

6. If you fix logical functions of your RTL code via 
recursive execution from Step 2 to Step 4, 
please launch  
`make HW_ACT=bit_gen vivado_prj`  
to generate system.bit in the top-level *hw_plat* directory via automatic 
synthesis, optimization, placement and routing. 
Please note that this command must be invoked after 
adder module is finished design, checking and simulation.


## FPGA Evaluation

We provide an FPGA cloud infrastructure 
for evaluation of this project, 
using a set of custom commands for 
hardware-software co-verification. 
The FPGA cloud is open-accessed 
any time any where via network 
until the course of this term finishes.  

1. In order to launch evaluation, please use either  
`make USER=<user_name> cloud_run`  
to connect to the FPGA cloud.
