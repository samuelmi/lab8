@echo off
REM ****************************************************************************
REM Vivado (TM) v2021.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Wed Oct 27 19:21:48 -0400 2021
REM SW Build 3247384 on Thu Jun 10 19:36:33 MDT 2021
REM
REM IP Build 3246043 on Fri Jun 11 00:30:35 MDT 2021
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
REM elaborate design
echo "xelab -wto 977881d1281f4a1c8b2ad1ab30f6ca26 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot controller_test_behav xil_defaultlib.controller_test xil_defaultlib.glbl -log elaborate.log"
call xelab  -wto 977881d1281f4a1c8b2ad1ab30f6ca26 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L uvm -L unisims_ver -L unimacro_ver -L secureip --snapshot controller_test_behav xil_defaultlib.controller_test xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0