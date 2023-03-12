# Erlang basics

## Message Passing

* `!` : "send" operator.
```
Pid ! Message
```

* `self()` : function that returns the process identifier (PID) of the currently executing process.

* `spawn(Module, Function, Args)` : creates a new process and returns its unique identifier (PID).

* `receive` : is used to receive and process messages sent to a process.
    * `after`: specify a timeout for receiving messages.

```
receive
    Pattern1 [when Guard1] -> Expression1;
    Pattern2 [when Guard2] -> Expression2;
    ...
    PatternN [when GuardN] -> ExpressionN

    after Timeout -> TimeoutExpression
end.
```

## Links

* `link(Pid)` : function that allows establishing a "link" or "connection" between two processes.
    * When two processes are linked, if one of the processes terminates abruptly, the other process also terminates abruptly. 
    * The link is bidirectional, meaning that both processes are linked to each other and can affect each other.

* `spawn_link(Module, Function, Args)` : creates a new process that runs the specified function in the given module, and links that process to the calling process.

* `unlink(Pid)` : break the link between the current process and another process specified.

## Signals 
* When a process ends a signal is sent to all the processes it was linked with.
* A process may end:
    * By ending its code (normal exit).
    * Due to a runtime error.
    * By an explicit order (kill).
* If a linked process does not catch the signal it will also die, signaling any process linked to it.

* `exit(Reason)` : end a process with reason *Reason*.
* `exit(Pid, Reason)` : sends an exit signal to process *Pid* with reason *Reason*.

* Reason may be: 
    * The atom *normal*, if the process finished normally. **Normal
exits do not kill linked processes.**
    * `kill`: created by exit/2. Kills the receiving process
unconditionally.
    * Any other Reason. It’s considered an anormal termination,
and propagates to all the linked processes.