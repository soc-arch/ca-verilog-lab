# Lab 5: SystemVerilog Conversion

## 학습 목표

- `logic` 타입으로 `wire`/`reg` 구분을 제거할 수 있다.
- `always_comb`, `always_ff`를 사용하여 설계 의도를 명시할 수 있다.
- `.name` (dot-name) 포트 연결을 활용할 수 있다.
- Verilog-2001 코드를 SystemVerilog로 자연스럽게 변환할 수 있다.

## 대응 강의 범위

- SystemVerilog Extensions (slides 111-125)

## SystemVerilog 핵심 변경점

### 1. `logic` — wire/reg 통합

Verilog에서는 `assign`으로 구동하면 `wire`, `always`에서 구동하면 `reg`로 선언해야 했습니다. SystemVerilog의 `logic`은 둘 다 대체합니다.

```verilog
// Verilog-2001
output wire       zero;
output reg  [7:0] y;

// SystemVerilog
output logic       zero;
output logic [7:0] y;
```

### 2. `always_comb` — 조합 논리 전용

`always @(*)`를 대체합니다. 도구가 조합 논리가 아닌 경우(latch 추론 등) 경고를 발생시킵니다.

```verilog
// Verilog-2001
always @(*) begin
    case (op) ...
    endcase
end

// SystemVerilog
always_comb begin
    case (op) ...
    endcase
end
```

### 3. `always_ff` — 순차 논리 전용

`always @(posedge clk or negedge rst_n)`을 대체합니다. 도구가 순차 논리가 아닌 경우 경고를 발생시킵니다.

```verilog
// Verilog-2001
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) ...
    else ...
end

// SystemVerilog
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) ...
    else ...
end
```

### 4. 포트 연결 스타일

SystemVerilog는 모듈 인스턴스화에서 간결한 포트 연결 방식을 추가합니다.

```verilog
// Named port (Verilog-2001) — 항상 안전, 가장 보편적
alu_unit u_alu (
    .a    (rdata1),
    .b    (alu_b),
    .op   (alu_op),
    .y    (alu_result),
    .zero (zero)
);

// Dot-name (SystemVerilog) — 포트와 신호 이름이 같을 때
// lowRISC/OpenTitan 등 naming convention이 잘 잡힌 프로젝트에서 선호
alu_unit u_alu (
    .a    (rdata1),     // 이름 다름 → named port 유지
    .b    (alu_b),      // 이름 다름 → named port 유지
    .op   (alu_op),     // 이름 다름 → named port 유지
    .y    (alu_result), // 이름 다름 → named port 유지
    .zero              // 이름 같음 → dot-name!
);

// Dot-star (SystemVerilog) — 이름이 모두 같을 때 자동 연결
// 편리하지만 어떤 포트가 연결됐는지 코드만으로 파악이 어려움
// 일부 팀/회사에서는 금지하기도 함
register8 u_reg0 (
    .*,                 // clk, rst_n 등 이름 일치하는 것 자동 연결
    .we  (we_vec[0]),   // 이름 다른 것만 명시
    .d   (wdata),
    .q   (reg0_q)
);
```

**권장 사항:**
- **named port `.port(signal)`을 기본으로 사용하세요.** 가장 명시적이고 안전합니다. 어떤 포트에 어떤 신호가 연결되는지 코드만 보고 바로 파악할 수 있습니다.
- **`.name` (dot-name)**: 포트와 신호 이름이 일치할 때 사용할 수 있습니다. naming convention이 잘 갖춰진 대규모 프로젝트(lowRISC/OpenTitan 등)에서 활용됩니다.
- **`.*` (dot-star)**: 빠른 프로토타이핑에 유용하나, "보이지 않는 연결"이 생겨 코드 리뷰와 유지보수에 불리합니다. 일부 팀/회사에서는 사용을 금지합니다.

이 Lab에서는 named port를 기본으로 하되, prob2와 prob3에서 dot-name도 선택적으로 시도해 볼 수 있습니다.

## 문제 목록

Lab 4의 문제를 SystemVerilog로 변환합니다. Testbench는 Verilog-2001 그대로 제공됩니다 (인터페이스 호환).

### Problem 1: ALU + Accumulator (SV) ★★☆

**파일:** `prob1/alu_acc.v`

Lab 4 Problem 1과 동일한 기능을 SystemVerilog로 구현하세요.

**변환 포인트:**
- 모든 `wire`/`reg` → `logic`
- ALU 조합 논리: `always_comb`
- Accumulator 레지스터: `always_ff`

---

### Problem 2: MUX + Decoder + Register (SV) ★★★

**파일:** `prob2/` 디렉토리 내 파일들

Lab 4 Problem 2와 동일한 기능을 SystemVerilog로 구현하세요.

**변환 포인트:**
- 모든 sub-module에서 `logic` 사용
- `decoder2to4`: `always_comb`
- `register8`: `always_ff`
- `top_mux_dec_reg`: named port 기본. 선택적으로 `.name` (dot-name) 시도 가능.

---

### Problem 3: Simple Datapath (SV) ★★★

**파일:** `prob3/` 디렉토리 내 파일들

Lab 4 Problem 3과 동일한 기능을 SystemVerilog로 구현하세요.

**변환 포인트:**
- `alu_unit`: `always_comb`
- `reg_file`: `always_ff` (write) + `always_comb` (read)
- `datapath`: named port 기본. 선택적으로 `.name` 시도 가능 (`clk`, `rst_n` 등 이름 일치하는 포트)

---

### Problem 4: Coding Style Review (SV) ★★☆

**파일:** `prob4/good_counter.v`

Lab 4 Problem 4의 `bad_counter.v`(동일 파일 제공)를 SystemVerilog 스타일로 리팩토링하세요.

**변환 포인트:**
- `wire`/`reg` → `logic`
- `always @(posedge ...)` → `always_ff`
- naming convention 적용 (Lab 4와 동일)
- Lab 4에서의 모든 수정 사항 + SV 변환

---

## 실행 방법

### Vivado
1. 파일 확장자가 `.v`이지만, Vivado는 내용으로 SystemVerilog를 자동 인식합니다.
2. 또는 파일을 `.sv`로 rename해도 됩니다.

### Verilator + Surfer
```bash
make sim PROB=prob1    # 시뮬레이션 실행
make all               # 전체 실행
make wave PROB=prob1   # waveform 확인
```

**Note:** Verilator는 기본적으로 SystemVerilog를 지원합니다. `.v` 확장자도 정상 동작합니다.
