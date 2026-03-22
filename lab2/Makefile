PROBLEMS = prob1 prob2 prob3 prob4 prob5

# Per-problem module name mapping
prob1_MOD = mux4to1
prob2_MOD = priority_enc
prob3_MOD = seven_seg
prob4_MOD = alu
prob5_MOD = barrel_shifter

mod = $($(PROB)_MOD)

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
		--top-module $(mod)_tb \
		$(mod)_tb.v $(mod).v \
		-o sim_$(mod) && \
	./obj_dir/sim_$(mod)

wave:
	@if [ -z "$(PROB)" ]; then echo "Usage: make wave PROB=prob1"; exit 1; fi
	cd $(PROB) && surfer dump.fst &

lint:
	@if [ -z "$(PROB)" ]; then echo "Usage: make lint PROB=prob1"; exit 1; fi
	cd $(PROB) && verilator --lint-only -Wall $(mod).v

clean:
	@for p in $(PROBLEMS); do \
		rm -rf $$p/obj_dir $$p/dump.fst $$p/dump.vcd; \
	done
