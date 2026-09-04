transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+clk_div_mmcm  -L xil_defaultlib -L xpm -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.clk_div_mmcm xil_defaultlib.glbl

do {clk_div_mmcm.udo}

run 1000ns

endsim

quit -force
