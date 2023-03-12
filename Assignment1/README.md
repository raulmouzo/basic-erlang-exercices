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

2. Store 

Implement a storage service that provides a way to retrieve elements that satisfy any given
predicate. The API should be:

* `store:start()`: start an store and return its PID.
* `store:store(S, E)`: store the element E in the store S.
* `store:get(S, F)`, where S is a store, and F is a predicate over elements. Get returns {error, no product} if none of the elements in the store satisfy the predicate, or {ok, P} where P is an element stored in S such that F(P) is true. P should be removed from the store.

```
-module(store).
-export([start/0, store/2, get/2]).
-export([loop/0]).

%% API
start() -> spawn(?MODULE, loop, []).
store(S, P) -> ...
get(S, F) -> ...

%% Internal Functions
loop() -> ...
```

Provide an implementation for store/2, get/2 and loop/0. You may add auxiliary functions and parameters to loop.