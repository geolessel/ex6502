defmodule Ex6502.CPU do
  @moduledoc """
  An emulation of the 6502 CPU as produced by WDC (WDC 65C02).

  The CPU has 6 registers, 3 of which are of general use.

  * `a` - 8-bit accumulator
  * `x` - 8-bit general use
  * `y` - 8-bit general use
  * `sp` - 8-bit stack pointer
  * `p` - 8-bit processor status flags. The bits represent, from MSB to LSB:
      * `N` - Negative
      * `V` - Overflow
      * `-` - Unused
      * `B` - Break command
      * `D` - Decimal mode
      * `I` - Interrupt disable
      * `Z` - Zero
      * `C` - Carry
  * `pc` - 16-bit program counter

  Special memory addresses include:

  * `$FFFA` - non masking interrupt
  * `$FFFC` - reset
  * `$FFFE` - IRQ
  """

  use Bitwise

  alias Ex6502.{Computer, CPU}

  @reset_vector 0xFFFC
  @flags %{c: 0, z: 1, i: 2, d: 3, b: 4, v: 6, n: 7}

  defstruct a: 0, x: 0, y: 0, sp: 0xFF, p: 0, pc: @reset_vector

  def init do
    %Ex6502.CPU{}
  end

  def step_pc(%CPU{} = cpu, amount \\ 1) do
    Map.update(cpu, :pc, @reset_vector, &(&1 + amount))
  end

  def set(%Computer{cpu: cpu, data_bus: value} = c, register) do
    Map.put(c, :cpu, Map.put(cpu, register, value))
  end

  def set(%Computer{cpu: cpu} = c, register, value) do
    Map.put(c, :cpu, Map.put(cpu, register, value))
  end

  def execute_instruction(%Computer{} = c) do
    Ex6502.CPU.Executor.execute(c)
  end

  def flag(%Computer{cpu: cpu}, flag) do
    (cpu.p &&& 1 <<< @flags[flag]) >>> @flags[flag] == 1
  end

  def set_flags(%Computer{cpu: cpu} = c, flags, register) when is_list(flags) do
    cpu =
      flags
      |> Enum.reduce(cpu, fn flag, acc ->
        pos = @flags[flag]

        if set_flag?(c, flag, register) do
          Map.put(acc, :p, acc.p ||| 1 <<< pos)
        else
          Map.put(acc, :p, acc.p &&& ~~~(1 <<< pos))
        end
      end)

    Map.put(c, :cpu, cpu)
  end

  def set_flag(%Computer{cpu: cpu} = c, flag, value) do
    Map.put(c, :cpu, Map.put(cpu, :p, set_bit(cpu.p, @flags[flag], value)))
  end

  def set_bit(p, pos, value) do
    if value == 0 || value == false do
      p &&& ~~~(1 <<< pos)
    else
      p ||| 1 <<< pos
    end
  end

  defp set_flag?(%Computer{cpu: cpu}, :z, register) do
    Map.get(cpu, register) == 0
  end

  defp set_flag?(%Computer{cpu: cpu}, :n, register) do
    # is bit 7 set?
    (Map.get(cpu, register) &&& 1 <<< 7) >>> 7 == 1
  end
end
