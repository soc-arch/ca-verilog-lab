# CA Verilog Lab

한양대학교 컴퓨터구조 과목 Verilog HDL Hands-on Lab 자료입니다.

## Lab 목록

| Lab | 주제 | 핵심 개념 |
|-----|------|----------|
| [Lab 1](lab1_comb_assign/) | Combinational Logic with `assign` | wire, assign, bitwise/arithmetic operators |
| [Lab 2](lab2_comb_always/) | Combinational Logic with `always @(*)` | always block, if/else, case, blocking assignment |
| [Lab 3](lab3_sequential/) | Sequential Logic | posedge clk, nonblocking assignment, async reset |
| [Lab 4](lab4_hierarchy/) | Hierarchy & Integration | module instantiation, datapath 설계, coding style |

## 환경 설정

### Option A: Vivado (권장 — Windows)

1. Xilinx Vivado를 설치합니다 (WebPACK Edition, 무료).
2. 각 Lab 폴더에서 Vivado 프로젝트를 생성합니다.
3. DUT 파일(skeleton)과 testbench 파일을 프로젝트에 추가합니다.
4. **Run Simulation → Run Behavioral Simulation**으로 실행합니다.
5. 콘솔에서 PASS/FAIL 결과를 확인하고, waveform 창에서 신호를 분석합니다.

### Option B: Verilator + Surfer (VSCode — macOS/Linux/WSL)

#### 설치

```bash
# Verilator 설치
# Ubuntu/WSL
sudo apt install verilator
# macOS
brew install verilator
```

Surfer (waveform viewer)는 **VSCode Extension**으로 설치하는 것이 가장 간편합니다:

1. VSCode에서 Extensions (Ctrl+Shift+X)를 엽니다.
2. **"Surfer"**를 검색하여 설치합니다.
3. 시뮬레이션 실행 후 생성된 `.fst` 파일을 VSCode에서 클릭하면 waveform이 바로 표시됩니다.

#### 사용법

각 Lab 디렉토리에서:

```bash
make lint           # 코드 lint 검사 (Verilator)
make sim PROB=prob1_halfadder   # 시뮬레이션 실행
make all            # 전체 문제 시뮬레이션
```

시뮬레이션 후 각 문제 폴더에 `dump.fst` 파일이 생성됩니다. VSCode에서 이 파일을 클릭하면 Surfer가 waveform을 표시합니다.

## 진행 방법

1. 이 저장소를 clone합니다:
   ```bash
   git clone https://github.com/soc-arch/ca-verilog-lab.git
   ```
2. 각 Lab의 `README.md`를 읽고 문제를 확인합니다.
3. `probN_xxx/` 폴더의 skeleton `.v` 파일에서 `// TODO` 부분을 작성합니다.
4. Testbench(`_tb.v`)는 수정하지 않습니다.
5. 시뮬레이션을 실행하여 **All tests passed!** 메시지를 확인합니다.

## 사용 HDL

- **Verilog-2001** (IEEE 1364-2001)
- SystemVerilog 문법은 사용하지 않습니다.
