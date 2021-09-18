defmodule Ex6502.ComputerServer do
  use GenServer

  alias Ex6502.Computer

  def start_link(computer, opts \\ []) do
    GenServer.start_link(__MODULE__, opts ++ [computer: computer])
  end

  def step(pid) do
    GenServer.call(pid, :step)
  end

  def load_file(pid, path) do
    GenServer.call(pid, {:load_file, path})
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  def get_computer(pid) do
    GenServer.call(pid, :get_computer)
  end

  def subscribe(pid, subscriber_pid) do
    GenServer.call(pid, {:subscribe, subscriber_pid})
  end

  def io_subscribe(pid, subscriber_pid, address_range) do
    GenServer.call(pid, {:io_subscribe, subscriber_pid, address_range})
  end

  def run(pid) do
    GenServer.cast(pid, :run)
  end

  def run(pid, clock) when clock >= 1 and clock <= 1_000 do
    GenServer.cast(pid, {:run, clock})
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  def send_io(pid, address, value) do
    GenServer.cast(pid, {:send_io, address, value})
  end

  ## SERVER API

  def init(computer: computer) do
    {:ok,
     %{
       computer: computer,
       running: false,
       clock: 0,
       running_timer: nil,
       subscribers: MapSet.new(),
       io_subscribers: MapSet.new()
     }}
  end

  def handle_call(:step, _from, state) do
    c = Computer.step(state.computer)
    {:reply, c, %{state | computer: c}}
  end

  def handle_call({:load_file, path}, _from, state) do
    c = Computer.load_file(state.computer, path)
    {:reply, c, %{state | computer: c}}
  end

  def handle_call(:reset, _from, state) do
    c = Computer.reset(state.computer)
    {:reply, c, %{state | computer: c}}
  end

  def handle_call(:get_computer, _from, state) do
    {:reply, state.computer, state}
  end

  def handle_call({:subscribe, subscriber_pid}, _from, state) do
    {:reply, :ok, %{state | subscribers: MapSet.put(state.subscribers, subscriber_pid)}}
  end

  def handle_call({:io_subscribe, subscriber_pid, address_range}, _from, state) do
    {:reply, :ok,
     %{state | computer: Computer.io_subscribe(state.computer, subscriber_pid, address_range)}}
  end

  def handle_call(:stop, _from, state) do
    state = handle_stop(state)

    {:reply, state.computer, state}
  end

  def handle_cast(:run, state) do
    c = Map.put(state.computer, :running, true)
    Process.send(self(), :step, [])
    {:noreply, %{state | computer: c, running: true}}
  end

  def handle_cast({:run, clock}, state) do
    c = Map.put(state.computer, :running, true)
    timer = Process.send_after(self(), :step, state.clock)
    {:noreply, %{state | computer: c, running_timer: timer, running: true, clock: clock}}
  end

  def handle_cast({:send_io, address, value}, state) do
    c = Computer.load(state.computer, address, [value])
    {:noreply, %{state | computer: c}}
  end

  def handle_info(:step, %{running: false} = state) do
    {:noreply, state}
  end

  def handle_info(:step, %{clock: clock} = state) do
    c = Computer.step(state.computer)

    notify_subscribers(state, c)

    if c.running do
      if clock > 0 do
        timer = Process.send_after(self(), :step, clock)

        {:noreply, %{state | computer: c, running_timer: timer}}
      else
        Process.send_after(self(), :step, 1)
        {:noreply, %{state | computer: c}}
      end
    else
      Process.send(self(), :stop, [])
      {:noreply, %{state | computer: c}}
    end
  end

  def handle_info(:stop, state) do
    state = handle_stop(state)
    {:noreply, state}
  end

  def cancel_timer(%{running_timer: nil} = state), do: state

  def cancel_timer(%{running_timer: timer} = state) do
    Process.cancel_timer(timer)
    state
  end

  def cancel_running(state), do: %{state | running: false}

  def reset_clock(state), do: %{state | clock: 0}

  def notify_subscribers(state, new_computer) do
    state.subscribers
    |> Stream.each(fn subscriber ->
      send(subscriber, {:step, new_computer})
    end)
    |> Stream.run()
  end

  def handle_stop(state) do
    state
    |> cancel_timer()
    |> cancel_running()
    |> reset_clock()
  end
end
