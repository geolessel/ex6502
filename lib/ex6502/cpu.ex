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

  use GenServer
  use Bitwise

  @initial_registers %{a: 0, x: 0, y: 0, sp: 0x01FF, p: 0, pc: 0xFFFC}
  @flags %{c: 0, z: 1, i: 2, d: 3, b: 4, v: 6, n: 7}

  # Client API

  def start(initial_registers \\ %{}) do
    GenServer.start_link(__MODULE__, initial_registers, name: __MODULE__)
  end

  def get(register) do
    GenServer.call(__MODULE__, {:get, register})
  end

  def set(register, value) when value <= 0xFF do
    GenServer.call(__MODULE__, {:set, register, value})
  end

  def set(:pc, value) when value <= 0xFFFF do
    GenServer.call(__MODULE__, {:set, :pc, value})
  end

  def set(_register, _too_large), do: {:error, :too_large}

  def set_flag(flag, value) do
    GenServer.call(__MODULE__, {:set_flag, flag, value})
  end

  def flag(flag) do
    GenServer.call(__MODULE__, {:flag, flag})
  end

  def advance_pc(amount \\ 1) do
    GenServer.call(__MODULE__, {:advance_pc, amount})
  end

  # Server API

  @impl true
  def init(initial_registers) do
    {:ok, Map.merge(@initial_registers, initial_registers)}
  end

  @impl true
  def handle_call({:get, register}, _from, state) do
    {:reply, Map.get(state, register), state}
  end

  @impl true
  def handle_call({:set, register, value}, _from, state) do
    state = Map.put(state, register, value)
    {:reply, {:ok, value}, state}
  end

  @impl true
  def handle_call({:set_flag, flag, value}, _from, state) do
    pos = @flags[flag]

    state =
      if value == false || value == 0 do
        Map.put(state, :p, state.p &&& ~~~(1 <<< pos))
      else
        Map.put(state, :p, state.p ||| 1 <<< pos)
      end

    {:reply, {:ok, value}, state}
  end

  @impl true
  def handle_call({:flag, flag}, _from, state) do
    status = (state.p &&& 1 <<< @flags[flag]) >>> @flags[flag]
    {:reply, status == 1, state}
  end

  @impl true
  def handle_call({:advance_pc, amount}, _from, state) do
    state = Map.update(state, :pc, 0, &(&1 + amount))

    if state.pc <= 0xFFFF do
      {:reply, {:ok, state.pc}, state}
    else
      {:reply, {:error, :out_of_bounds}, state}
    end
  end
end
