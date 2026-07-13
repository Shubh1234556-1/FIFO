# 8×8 Synchronous FIFO

A small Verilog project implementing an 8-entry × 8-bit synchronous FIFO with a write-side feeder and a read-side FSM controller.

**Process:** `top__fifo` → `mod_a` (write feeder) → `fifo_8_8` (storage) → `mod__b` (read FSM)

```
data_top -> [mod_a] --data/wr_enb--> [fifo_8_8] --data/empty--> [mod__b] -> data_out_top
                                          ^-------------rd_enb-------------|
```

## Modules

### `top__fifo`
Top-level wrapper. Ports: `clk`, `rst`, `data_top[7:0]` in, `data_out_top[7:0]` out. Wires `mod_a` → `fifo_8_8` → `mod__b` together.

### `mod_a` — write feeder
Registers `data_in` every cycle and asserts `wr_enb`.
> ⚠️ `wr_enb` is unconditional — it doesn't check `full`. Route `full` from `fifo_8_8` back in and gate writes (`wr_enb <= !full;`) to avoid overwriting data.

### `fifo_8_8` — FIFO core
8×8 register array with 3-bit `wr_ptr`/`rd_ptr`.
- Write: if `wr_en && !full`, store at `mem[wr_ptr]`, increment pointer.
- Read: if `rd_en && !empty`, register `mem[rd_ptr]` to `data_out` (1-cycle latency), increment pointer.
- `full = (wr_ptr + 1 == rd_ptr)`, `empty = (wr_ptr == rd_ptr)` — pointer-comparison scheme, so true usable capacity is 7, not 8.

### `mod__b` — read FSM
3-state FSM: `idle` → `s1` → `data_state`.
- **idle:** if `!empty`, pulse `rd_enb` and move to `s1`.
- **s1:** wait one cycle for the FIFO's registered output to update.
- **data_state:** capture `data_in` into `data_out`, return to `idle`.

This sequencing correctly handles the FIFO's 1-cycle read latency.

## File Structure
```
top__fifo.v
mod_a.v
fifo_8_8.v
mod__b.v
README.md
```
