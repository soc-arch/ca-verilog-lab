# Lab 2: Combinational Logic with `always @(*)`

## 학습 목표

- `always @(*)`와 blocking assignment (`=`)를 사용하여 조합 논리를 기술할 수 있다.
- `case` 문을 사용하여 truth table 기반 논리를 구현할 수 있다.
- `if/else` 문으로 priority logic을 구현할 수 있다.
- Default assignment를 통해 latch inference를 방지할 수 있다.
- `assign`과 `always @(*)`의 사용 기준을 구분할 수 있다.

## 대응 강의 범위

- Part 2: Combinational Logic Mapping, Worked Examples, Misconceptions

## 문제 목록

### Problem 1: 4:1 Multiplexer ★☆☆

**파일:** `prob1/mux4to1.v`

`case` 문을 사용하여 4:1 MUX를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 8 | Data input 0 |
| `b` | input | 8 | Data input 1 |
| `c` | input | 8 | Data input 2 |
| `d` | input | 8 | Data input 3 |
| `sel` | input | 2 | Select signal |
| `y` | output | 8 | Selected output |

| `sel` | `y` |
|-------|-----|
| 2'b00 | `a` |
| 2'b01 | `b` |
| 2'b10 | `c` |
| 2'b11 | `d` |

**주의:** `y`는 `always` 블록에서 구동하므로 `reg`로 선언해야 합니다.

---

### Problem 2: Priority Encoder ★★☆

**파일:** `prob2/priority_enc.v`

4-bit request 입력에서 가장 높은 우선순위의 활성 요청을 인코딩하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `req` | input | 4 | Request inputs (req[3] = highest priority) |
| `enc` | output | 2 | Encoded output |
| `valid` | output | 1 | High when any request is active |

**동작:**
- `req[3]`=1 → `enc`=3, `valid`=1
- `req[3:2]`=01 → `enc`=2, `valid`=1
- `req[3:1]`=001 → `enc`=1, `valid`=1
- `req[3:0]`=0001 → `enc`=0, `valid`=1
- `req`=0000 → `enc`=0, `valid`=0

**힌트:** `if/else` chain + default assignments at top.

---

### Problem 3: 7-Segment Decoder ★★☆

**파일:** `prob3/seven_seg.v`

4-bit BCD 입력(0~9)을 7-segment display 패턴으로 변환하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `bcd` | input | 4 | BCD input (0-9) |
| `seg` | output | 7 | 7-segment output (seg[6:0] = g,f,e,d,c,b,a) |

세그먼트 매핑 (active-high, seg[6]=g ~ seg[0]=a):
```
  aaa
 f   b
  ggg
 e   c
  ddd
```

| BCD | Display | seg[6:0] (gfedcba) |
|-----|---------|---------------------|
| 0 | 0 | 7'b0111111 |
| 1 | 1 | 7'b0000110 |
| 2 | 2 | 7'b1011011 |
| 3 | 3 | 7'b1001111 |
| 4 | 4 | 7'b1100110 |
| 5 | 5 | 7'b1101101 |
| 6 | 6 | 7'b1111101 |
| 7 | 7 | 7'b0000111 |
| 8 | 8 | 7'b1111111 |
| 9 | 9 | 7'b1101111 |
| others | blank | 7'b0000000 |

**힌트:** `case` 문으로 각 숫자에 대응하는 패턴을 지정하고, `default`로 invalid 입력을 처리합니다.

---

### Problem 4: Simple ALU ★★★

**파일:** `prob4/alu.v`

3-bit `op` 신호에 따라 8-bit 산술/논리 연산을 수행하는 ALU를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `a` | input | 8 | Operand A |
| `b` | input | 8 | Operand B |
| `op` | input | 3 | Operation select |
| `y` | output | 8 | Result |
| `zero` | output | 1 | 1 when y == 0 |

| `op` | 연산 | 설명 |
|------|------|------|
| 3'b000 | `a + b` | Addition |
| 3'b001 | `a - b` | Subtraction |
| 3'b010 | `a & b` | Bitwise AND |
| 3'b011 | `a \| b` | Bitwise OR |
| 3'b100 | `a ^ b` | Bitwise XOR |
| 3'b101 | `~a` | Bitwise NOT |
| 3'b110 | `a << 1` | Shift left by 1 |
| 3'b111 | `a >> 1` | Logical shift right by 1 |

**힌트:** `case` 문으로 `y`를 결정하고, `zero`는 별도의 `assign` 문으로 구현할 수 있습니다.

---

### Problem 5: Barrel Shifter ★★★

**파일:** `prob5/barrel_shifter.v`

8-bit 입력을 `shamt`(shift amount)만큼 왼쪽으로 rotate하는 barrel shifter를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `data` | input | 8 | Input data |
| `shamt` | input | 3 | Shift/rotate amount (0-7) |
| `y` | output | 8 | Rotated output |

**동작:** Left rotate — 밀려나간 MSB 비트가 LSB 쪽으로 들어옵니다.
- `shamt`=0 → `y` = `data`
- `shamt`=1 → `y` = {data[6:0], data[7]}
- `shamt`=2 → `y` = {data[5:0], data[7:6]}
- ...

**힌트:** `case` 문 또는 concatenation을 활용합니다: `y = {data, data} >> (8 - shamt)` 같은 트릭도 가능합니다.

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
