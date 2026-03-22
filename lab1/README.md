# Lab 1: Combinational Logic with `assign`

## 학습 목표

- `wire`와 `assign`을 사용하여 조합 논리를 기술할 수 있다.
- Bitwise, arithmetic, relational 연산자를 올바르게 활용할 수 있다.
- Ternary operator (`? :`)를 사용하여 MUX 동작을 기술할 수 있다.
- Reduction operator를 이해하고 활용할 수 있다.
- `parameter`를 사용하여 재사용 가능한 모듈을 설계할 수 있다.

## 대응 강의 범위

- Part 1: Module Structure & Data Types, Basic Operators, Continuous Assignment
- Part 2: Combinational Logic Mapping (assign 부분)

## 문제 목록

### Problem 1: Half Adder ★☆☆

**파일:** `prob1/halfadder.v`

1-bit half adder를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 1 | Operand A |
| `b` | input | 1 | Operand B |
| `sum` | output | 1 | Sum (a XOR b) |
| `cout` | output | 1 | Carry out (a AND b) |

**힌트:** XOR(`^`)와 AND(`&`) 연산자를 사용합니다.

---

### Problem 2: Full Adder ★☆☆

**파일:** `prob2/fulladder.v`

1-bit full adder를 설계하세요. 중간 wire를 선언하여 사용해도 됩니다.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 1 | Operand A |
| `b` | input | 1 | Operand B |
| `cin` | input | 1 | Carry in |
| `sum` | output | 1 | Sum |
| `cout` | output | 1 | Carry out |

**힌트:** `sum = a ^ b ^ cin`, `cout = (a & b) | (cin & (a ^ b))`

---

### Problem 3: 8-bit Bitwise ALU ★★☆

**파일:** `prob3/alu8bit.v`

2-bit `op` 신호에 따라 8-bit 입력 `a`, `b`에 대해 서로 다른 bitwise 연산을 수행하는 ALU를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 8 | Operand A |
| `b` | input | 8 | Operand B |
| `op` | input | 2 | Operation select |
| `y` | output | 8 | Result |

| `op` | 연산 |
|------|------|
| 2'b00 | `a & b` (AND) |
| 2'b01 | `a \| b` (OR) |
| 2'b10 | `a ^ b` (XOR) |
| 2'b11 | `~a` (NOT A) |

**힌트:** Nested ternary operator (`? :`)를 사용합니다.

---

### Problem 4: Zero and Sign Detector ★★☆

**파일:** `prob4/detector.v`

8-bit 입력을 2's complement로 해석하여 zero, negative, positive 플래그를 생성하세요. (Verilog 코드에서 `signed` 키워드를 사용할 필요는 없습니다 — 비트 패턴만으로 판별할 수 있습니다.)

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `data` | input | 8 | 8-bit data (2's complement representation) |
| `is_zero` | output | 1 | 1 if data == 0 |
| `is_neg` | output | 1 | 1 if data is negative (MSB == 1) |
| `is_pos` | output | 1 | 1 if data > 0 (not zero, not negative) |

**힌트:** Reduction OR (`|data`)로 zero 검사, bit-select (`data[7]`)로 부호 검사.

---

### Problem 5: Parameterized Adder ★★★

**파일:** `prob5/param_adder.v`

`parameter`를 사용하여 bit-width를 설정할 수 있는 unsigned adder를 설계하세요. 기본값은 8-bit입니다. 모든 입출력은 unsigned로 동작합니다.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | WIDTH | Operand A |
| `b` | input | WIDTH | Operand B |
| `cin` | input | 1 | Carry in |
| `sum` | output | WIDTH | Sum |
| `cout` | output | 1 | Carry out |

Parameter: `WIDTH` (default = 8)

**힌트:** `{cout, sum} = a + b + cin;` — concatenation을 활용합니다.

---

## 실행 방법

### Vivado
1. 각 문제의 `.v` 파일과 `_tb.v` 파일을 프로젝트에 추가합니다.
2. Simulation Sources에서 `_tb` 모듈을 top으로 설정합니다.
3. Run Behavioral Simulation을 실행합니다.

### Verilator + Surfer
```bash
make sim PROB=prob1              # 개별 실행
make all                         # 전체 실행
make wave PROB=prob1             # waveform 확인
make lint PROB=prob1             # lint 검사
```
