# Lab 4: Hierarchy & Integration

## 학습 목표

- 서로 다른 기능의 모듈을 인스턴스화하고 연결하여 더 큰 시스템을 구성할 수 있다.
- Named port connection을 사용하여 모듈을 안전하게 연결할 수 있다.
- Combinational logic과 sequential logic을 분리하여 설계할 수 있다.
- Datapath 구조(ALU + Register + MUX)를 이해하고 구현할 수 있다.
- Coding style (naming convention, `default_nettype none`)을 실무에 적용할 수 있다.

## 대응 강의 범위

- Part 1: Creating Hierarchy, Named Port Connection
- Part 2: 전체 (Combinational + Sequential Mapping)
- Part 3: Naming Conventions, Design Rules, Code Verification Checklist

## 문제 목록

### Problem 1: ALU + Accumulator ★★☆

**파일:** `prob1/alu_acc.v`

Lab 2에서 설계한 것과 같은 ALU(조합 논리)와 accumulator register(순차 논리)를 결합합니다. ALU와 register를 **같은 파일 내에서 별도의 always/assign 블록으로 분리**하여 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `b` | input | 8 | ALU operand B |
| `op` | input | 3 | ALU operation select |
| `en` | input | 1 | Accumulator write enable |
| `acc` | output | 8 | Accumulator value |
| `zero` | output | 1 | Zero flag (acc == 0) |

**ALU 연산** (Lab 2 Problem 4와 동일):

| `op` | 연산 |
|------|------|
| 3'b000 | acc + b |
| 3'b001 | acc - b |
| 3'b010 | acc & b |
| 3'b011 | acc \| b |
| 3'b100 | acc ^ b |
| 3'b101 | ~acc |
| 3'b110 | acc << 1 |
| 3'b111 | acc >> 1 |

**동작:**
- ALU는 현재 `acc` 값과 `b`를 입력으로 받아 `alu_result`를 계산 (조합 논리)
- `en`=1이면 매 clock edge에 `acc` ← `alu_result` (순차 논리)
- `rst_n`=0 → `acc`=0

**설계 구조:**
```
         +-------+
  b ---->|       |
         |  ALU  |---> alu_result --+
  acc -->| (comb)|                  |
         +-------+                  v
                              +----------+
                       en --->| Register |---> acc
                      clk --->| (seq)    |
                    rst_n --->|          |
                              +----------+
```

**힌트:** Combinational part(`always @(*)` 또는 `assign`)와 sequential part(`always @(posedge clk ...)`)를 명확히 분리하세요.

---

### Problem 2: MUX + Decoder + Register 조합 ★★★

**파일:** `prob2/` 디렉토리 내 파일들

3개의 서로 다른 모듈을 설계하고, top 모듈에서 이들을 인스턴스화하여 연결합니다.

#### Sub-module 1: `mux2to1.v`
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 8 | Input 0 |
| `b` | input | 8 | Input 1 |
| `sel` | input | 1 | Select |
| `y` | output | 8 | sel=0→a, sel=1→b |

#### Sub-module 2: `decoder2to4.v`
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `in` | input | 2 | 2-bit input |
| `en` | input | 1 | Enable |
| `out` | output | 4 | One-hot decoded output (en=0 → all 0) |

#### Sub-module 3: `register8.v`
| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low async reset |
| `we` | input | 1 | Write enable |
| `d` | input | 8 | Data input |
| `q` | output | 8 | Stored value |

#### Top module: `top_mux_dec_reg.v`

4개의 8-bit register를 갖고, decoder로 write 대상을 선택하고, MUX로 read 대상을 선택하는 간단한 register bank입니다.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low async reset |
| `wdata` | input | 8 | Write data |
| `waddr` | input | 2 | Write address (0-3) |
| `we` | input | 1 | Write enable |
| `raddr` | input | 2 | Read address (0-3) |
| `rdata` | output | 8 | Read data |

**구조:**
```
waddr ---> [decoder2to4] ---> we0, we1, we2, we3
                                |    |    |    |
wdata ------+---+---+---+-----v    v    v    v
            |   |   |   |    [reg0][reg1][reg2][reg3]
            |   |   |   |      |     |     |     |
            |   |   |   +------+-----+-----+-----+---> MUX chain
            |   |   |                                     |
raddr ------------------------------------------------> [mux] ---> rdata
```

**힌트:** 4개의 register 출력 중 하나를 선택하는 데 2:1 MUX를 3개 사용하거나(tree 구조), `case`문의 `always @(*)`를 직접 사용할 수 있습니다. 여기서는 MUX 모듈 인스턴스화를 연습하기 위해 **MUX tree** 방식을 권장합니다.

---

### Problem 3: Simple Datapath ★★★

**파일:** `prob3/` 디렉토리 내 파일들

ALU, MUX, Register를 연결한 미니 datapath를 설계하세요. 컴퓨터구조에서 배우는 datapath의 축소 버전입니다.

#### Sub-modules (새로 작성):

**`alu_unit.v`** — 8-bit ALU (Lab 2 Problem 4와 동일 인터페이스)

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a`, `b` | input | 8 | Operands |
| `op` | input | 3 | Operation |
| `y` | output | 8 | Result |
| `zero` | output | 1 | Zero flag |

**`reg_file.v`** — 4-entry x 8-bit register file

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Async reset |
| `raddr1` | input | 2 | Read address 1 |
| `raddr2` | input | 2 | Read address 2 |
| `waddr` | input | 2 | Write address |
| `wdata` | input | 8 | Write data |
| `we` | input | 1 | Write enable |
| `rdata1` | output | 8 | Read data 1 |
| `rdata2` | output | 8 | Read data 2 |

**`mux2to1_8bit.v`** — 8-bit 2:1 MUX

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a`, `b` | input | 8 | Inputs |
| `sel` | input | 1 | Select |
| `y` | output | 8 | Output |

#### Top module: `datapath.v`

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Async reset |
| `raddr1` | input | 2 | Register read address 1 (ALU input A) |
| `raddr2` | input | 2 | Register read address 2 (ALU input B or immediate) |
| `waddr` | input | 2 | Register write address |
| `we` | input | 1 | Register write enable |
| `alu_op` | input | 3 | ALU operation |
| `imm` | input | 8 | Immediate value |
| `src_b_sel` | input | 1 | 0=register, 1=immediate for ALU input B |
| `alu_result` | output | 8 | ALU result (also written to register file) |
| `zero` | output | 1 | Zero flag from ALU |

**구조:**
```
raddr1 ---> [reg_file] ---> rdata1 ---> ALU input A
raddr2 ---> [reg_file] ---> rdata2 --+
                                      +--> [MUX] ---> ALU input B
                              imm ---+    (src_b_sel)
                                              |
                                              v
                                           [ALU] ---> alu_result ---> wdata (to reg_file)
                                              |
                                              +--> zero
```

---

### Problem 4: Coding Style Review ★★☆

**파일:** `prob4/bad_counter.v`

아래 "나쁜 코드"가 제공됩니다. 강의 Part 3 (Coding Style)과 Part 2 (Mapping Rules)에서 배운 내용을 적용하여 `good_counter.v`로 리팩토링하세요.

**수정해야 할 항목:**
1. `default_nettype none` 추가
2. Naming convention 적용 (snake_case, `_n` for active-low, etc.)
3. Combinational/sequential logic 분리
4. Blocking/nonblocking assignment 올바르게 사용
5. Latch inference 방지 (default assignment)
6. 기타 coding style 위반 사항 수정

제공되는 `bad_counter.v`를 읽고, `good_counter.v`에 올바른 코드를 작성하세요. Testbench는 `good_counter.v`의 인터페이스에 맞춰져 있습니다.

---

## 실행 방법

### Vivado
1. 각 문제의 모든 `.v` 파일과 `_tb.v` 파일을 프로젝트에 추가합니다.
2. Simulation Sources에서 `_tb` 모듈을 top으로 설정합니다.
3. Run Behavioral Simulation을 실행합니다.

### Verilator + Surfer
```bash
make sim PROB=prob1                   # 개별 실행
make all                              # 전체 실행
make wave PROB=prob1                  # waveform 확인
```

**Note:** Lab 4의 일부 문제는 여러 `.v` 파일이 필요합니다. Makefile이 자동으로 처리합니다.
