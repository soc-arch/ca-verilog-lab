# Lab 3: Sequential Logic

## 학습 목표

- `always @(posedge clk)`을 사용하여 순차 논리를 기술할 수 있다.
- Nonblocking assignment (`<=`)의 의미와 필요성을 이해한다.
- Asynchronous reset (`negedge rst_n`)을 올바르게 구현할 수 있다.
- Sequential procedure template을 정확히 따를 수 있다.
- Combinational과 sequential logic의 분리 원칙을 적용할 수 있다.

## 대응 강의 범위

- Part 2: Sequential Logic Mapping, Worked Examples (Counter)
- Part 3: Design Rules (no logic on reset/clock)

## 문제 목록

### Problem 1: D Flip-Flop with Async Reset ★☆☆

**파일:** `prob1/dff.v`

Active-low asynchronous reset을 갖는 D flip-flop을 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `d` | input | 1 | Data input |
| `q` | output | 1 | Data output |

**동작:**
- `rst_n`=0 → `q`=0 (비동기 리셋)
- Rising edge of `clk` → `q` ← `d`

**힌트:** `always @(posedge clk or negedge rst_n)` template을 사용합니다.

---

### Problem 2: 4-bit Counter with Enable ★★☆

**파일:** `prob2/counter.v`

Enable 기능이 있는 4-bit up counter를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `en` | input | 1 | Count enable |
| `count` | output | 4 | Counter value |

**동작:**
- `rst_n`=0 → `count`=0
- Rising edge of `clk`, `en`=1 → `count` ← `count` + 1
- Rising edge of `clk`, `en`=0 → `count` 유지

---

### Problem 3: Shift Register (SIPO) ★★☆

**파일:** `prob3/shift_reg.v`

Serial-In, Parallel-Out (SIPO) shift register를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `serial_in` | input | 1 | Serial data input |
| `parallel_out` | output | 8 | Parallel output (8-bit) |

**동작:**
- `rst_n`=0 → `parallel_out`=0
- Rising edge of `clk` → 전체 레지스터를 왼쪽으로 1-bit shift, `serial_in`이 LSB로 입력
- 즉, `parallel_out` ← `{parallel_out[6:0], serial_in}`

---

### Problem 4: Up/Down Counter with Load ★★★

**파일:** `prob4/updown_counter.v`

방향 제어와 병렬 load 기능을 갖는 8-bit counter를 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `load` | input | 1 | Parallel load enable (highest priority after reset) |
| `en` | input | 1 | Count enable |
| `up` | input | 1 | Direction: 1=up, 0=down |
| `data` | input | 8 | Parallel load data |
| `count` | output | 8 | Counter value |

**동작 우선순위:**
1. `rst_n`=0 → `count`=0
2. `load`=1 → `count` ← `data`
3. `en`=1, `up`=1 → `count` ← `count` + 1
4. `en`=1, `up`=0 → `count` ← `count` - 1
5. otherwise → `count` 유지

---

### Problem 5: PWM Generator ★★★

**파일:** `prob5/pwm.v`

8-bit duty cycle 값에 따라 PWM 신호를 생성하는 모듈을 설계하세요.

| Port | Direction | Width | Description |
|------|-----------|-------|-------------|
| `clk` | input | 1 | Clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `duty` | input | 8 | Duty cycle value (0-255) |
| `pwm_out` | output | 1 | PWM output signal |

**동작:**
- 내부 8-bit free-running counter가 매 clock edge마다 증가 (0→1→...→255→0→...)
- `pwm_out` = 1 when counter < duty, 0 otherwise
- `rst_n`=0 → counter=0, `pwm_out`=0

**힌트:** Sequential part (counter)와 combinational part (비교)를 분리하여 설계합니다.
- `always @(posedge clk or negedge rst_n)` → counter
- `assign pwm_out = (counter < duty);` → combinational comparison

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
