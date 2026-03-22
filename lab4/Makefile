PROBLEMS = prob1 prob2 prob3 prob4

# Per-problem source file lists and top modules
prob1_SRCS        = alu_acc_tb.v alu_acc.v
prob1_TOP         = alu_acc_tb

prob2_SRCS        = top_mux_dec_reg_tb.v top_mux_dec_reg.v mux2to1.v decoder2to4.v register8.v
prob2_TOP         = top_mux_dec_reg_tb

prob3_SRCS        = datapath_tb.v datapath.v alu_unit.v reg_file.v mux2to1_8bit.v
prob3_TOP         = datapath_tb

prob4_SRCS        = good_counter_tb.v good_counter.v
prob4_TOP         = good_counter_tb

.PHONY: all sim wave lint clean

all:
	@for p in $(PROBLEMS); do \
		echo "===== $$p ====="; \
		$(MAKE) sim PROB=$$p; \
		echo ""; \
	done

sim:
	@if [ -z "$(PROB)" ]; then echo "Usage: make sim PROB=prob1"; exit 1; fi
	cd $(PROB) && verilator --binary --trace-fst -Wall \
		-Wno-DECLFILENAME -Wno-WIDTHEXPAND \
		--top-module $($(PROB)_TOP) \
		$($(PROB)_SRCS) \
		-o sim_out && \
	./obj_dir/sim_out

wave:
	@if [ -z "$(PROB)" ]; then echo "Usage: make wave PROB=prob1"; exit 1; fi
	cd $(PROB) && surfer dump.fst &

lint:
	@if [ -z "$(PROB)" ]; then echo "Usage: make lint PROB=prob1"; exit 1; fi
	cd $(PROB) && verilator --lint-only -Wall \
		$(filter-out %_tb.v,$($(PROB)_SRCS))

clean:
	@for p in $(PROBLEMS); do \
		rm -rf $$p/obj_dir $$p/dump.fst $$p/dump.vcd; \
	done
