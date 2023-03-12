## Assigment 1

1. Notifier 

Implement a message propagation service. The API of this service should have the following three functions:
* `notifier:start()`: starts a new notifier and returns its PID.
* `notifier:register(N)`: registers the calling process in the notifier N.
* `notifier:send(N, Msg)`: send the message Msg to every process registered in N.

```
-module(notifier).

-export([start/0, register/1, send/2]).
-export([loop/...]).

%% API
start() -> spawn(?MODULE, loop, []).
register(N) -> ...
send(N, Msg) -> ...

%% Internal Functions
loop() -> ...
```

Provide an implementation for the send/2, register/1 and loop functions. You may add parameter to loop.