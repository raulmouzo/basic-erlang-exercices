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

**Provide an implementation for the send/2, register/1 and loop functions. You may add parameter to loop.**

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

**Provide an implementation for store/2, get/2 and loop/0. You may add auxiliary functions and parameters to loop.**


3. Process Tree 

We have a module which implements an n-ary process tree, where each node in the tree is a separate process which stores a list with the pids of its children. We can create nodes using start node/0, and add new children to an existing node calling add child/2.

```
-module(tree).
-export([start_node/0, add_child/2, height/1]).

%% API
start_node() ->
    spawn(?MODULE, init_node, []).

add_child(Tree, Child_Tree) ->
    Tree ! {add_child, Child_Tree}.

height(Tree) ->
    ...

%% Internal functions
init_node() ->
    node_loop([]).

node_loop(Children) ->
    receive
        {add_child, Child_Tree} ->
            node_loop(Children ++ [Child_Tree]);
        ... 
    end.
```

**Write a function height/1 that returns the height of the tree of processes.**