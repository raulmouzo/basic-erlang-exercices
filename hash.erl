-module(hash).
-export([start/0, store/3, get/2, del/2, stop/1]). %Api
-export([init/0]). %For spawm.

%%%API 

start() -> 
    spawn(?MODULE, init, []).

store(Hash, Key, Value) -> 
    Hash ! {store, Key, Value}.

get(Hash, Key) -> 
    Hash ! {get, Key, self()},
    receive 
        {hash_ok, V} -> 
            {ok, V};
        {hash_error, Reason} -> 
            {error, Reason}
    end.

del(Hash, Key) -> 
    Hash ! {del, Key}.

stop(Hash) -> 
    Hash ! stop.


%%% Internal functions

init() -> 
    loop([]).

loop(D) -> 
    receive 
        {store, NK, NV} -> 
            loop([{NK, NV} | del_key(NK, D)]);
        {get, NK, From} -> 
            From ! find(NK, D), %%Response returns value v
            loop(D);
        {del, KD} ->
            loop(del_key(KD,D ));
        stop ->
            ok
    end.

%% Hash functions 

del_key(K,D) -> 
    [{Key, Val} || {Key, Val} <- D, Key/=K]. %% "/=" inequality
%% The || operator in Erlang is used to generate a list that meets certain conditions using list comprehension syntax. It adds an element to the resulting list if a certain condition is met. 
%%In this case, a new list is generated with all the elements except the one we want to delete.

find(_, []) -> 
    {hash_error, not_found};
find(K, [{K, V} | _]) -> 
    {hash_ok, V};
find(K, [_|T]) -> find(K, T).

