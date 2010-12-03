VINCDIR=                                  \
	                 \
	                    \


SYN_SRC=

SIM_SRC=                                  \
	wb_gpio_tb.v                           \


SRC=                                      \
	../wb_gpio.v                              \
	

#############################################################################
# Synthesis constants
SYNCLEAN=wb_gpio.bgn wb_gpio.drc wb_gpio.mrp wb_gpio.ngd wb_gpio.pcf 
SYNCLEAN+=wb_gpio.bld wb_gpio.lso wb_gpio.ncd wb_gpio.ngm wb_gpio.srp
SYNCLEAN+=wb_gpio.bit wb_gpio_signalbrowser.* wb_gpio-routed_pad.tx
SYNCLEAN+=wb_gpio.map wb_gpio_summary.xml timing.twr
SYNCLEAN+=wb_gpio-routed* wb_gpio_usage* wb_gpio.ngc param.opt netlist.lst
SYNCLEAN+=xst wb_gpio.prj *ngr *xrpt  _xmsgs  xlnx_auto_0_xdb *html *log *xwbt

USAGE_DEPTH=0
SMARTGUIDE= 

#############################################################################
# Simulation constants
SIMCLEAN=wb_gpio_tb.vvp wb_gpio_tb.vcd verilog.log wb_gpio_tb.vvp.list simulation

CVER=cver
GTKWAVE=gtkwave
IVERILOG=iverilog
VVP=vvp
	
#############################################################################
# 
sim: wb_gpio_tb.vcd
syn: wb_gpio.bit
view: wb_gpio_tb.view

#############################################################################
# Ikarus verilog simulation

wb_gpio_tb.vvp:
	rm -rf  simulation && mkdir simulation
	cp wb_gpio_tb.v  simulation && cd simulation && rm -f $@.list
	for i in $(SRC); do echo $$i >> simulation/$@.list; done
	for i in $(SIM_SRC); do echo $$i >> simulation/$@.list; done
	cd simulation && $(IVERILOG) -o $@ $(VINCDIR) -c $@.list -s $(@:.vvp=)

%.vcd: %.vvp
	cd simulation && $(VVP) $<

#############################################################################
# ISE Synthesis


wb_gpio.prj:
	rm -rf build && mkdir build
	@rm -f $@
	for i in $(SRC); do echo verilog work $$i >> build/$@; done
	for i in $(SRC_HDL); do echo VHDL work $$i >> build/$@; done

wb_gpio.ngc: wb_gpio.prj
	cd build && xst -ifn ../wb_gpio.xst

wb_gpio.ngd: wb_gpio.ngc wb_gpio.ucf
	cd build && ngdbuild -uc ../wb_gpio.ucf wb_gpio.ngc

wb_gpio.ncd: wb_gpio.ngd
	cd build && map $(SMARTGUIDE) wb_gpio.ngd

wb_gpio-routed.ncd: wb_gpio.ncd
	cd build && par $(SMARTGUIDE) -ol high -w wb_gpio.ncd wb_gpio-routed.ncd

wb_gpio.bit: wb_gpio-routed.ncd
	cd build &&  bitgen -w wb_gpio-routed.ncd wb_gpio.bit
	@mv -f build/wb_gpio.bit $@

wb_gpio.mcs: wb_gpio.bit
	cd build && promgen -u 0 wb_gpio

wb_gpio-routed.xdl: wb_gpio-routed.ncd
	cd build && xdl -ncd2xdl wb_gpio-routed.ncd wb_gpio-routed.xdl

wb_gpio-routed.twr: wb_gpio-routed.ncd
	cd build &&  trce -v 10 wb_gpio-routed.ncd wb_gpio.pcf

timing: wb_gpio-routed.twr

usage: wb_gpio-routed.xdl
	xdlanalyze.pl wb_gpio-routed.xdl $(USAGE_DEPTH)

####################################################################
# final targets

%.view: %.vcd
	cd simulation && $(GTKWAVE) $< $<.save

clean:
	rm -Rf build $(SYNCLEAN) $(SIMCLEAN) 

.PHONY: clean view
