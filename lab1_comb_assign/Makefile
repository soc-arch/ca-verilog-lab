PROBLEMS = prob1_halfadder prob2_fulladder prob3_alu8bit prob4_detector prob5_param_adder

# Extract module name from directory name (strip probN_ prefix)
mod = $(shell echo $(PROB) | sed 's/^prob[0-9]*_//')

.PHONY: all sim wave lint clean

all:
	@for p in $(PROBLEMS); do \
		echo "===== $$p ====="; \
		$(MAKE) sim PROB=$$p; \
		echo ""; \
	done

sim:
	@if [ -z "$(PROB)" ]; then echo "Usage: make sim PROB=prob1_halfadder"; exit 1; fi
	cd $(PROB) && verilator --binary --trace-fst -Wall \
		-Wno-DECLFILENAME -Wno-WIDTHEXPAND \
		--top-module $(mod)_tb \
		$(mod)_tb.v $(mod).v \
		-o sim_$(mod) && \
	./obj_dir/sim_$(mod)

wave:
	@if [ -z "$(PROB)" ]; then echo "Usage: make wave PROB=prob1_halfadder"; exit 1; fi
	cd $(PROB) && surfer dump.fst &

lint:
	@if [ -z "$(PROB)" ]; then echo "Usage: make lint PROB=prob1_halfadder"; exit 1; fi
	cd $(PROB) && verilator --lint-only -Wall $(mod).v

clean:
	@for p in $(PROBLEMS); do \
		rm -rf $$p/obj_dir $$p/dump.fst $$p/dump.vcd; \
	done
