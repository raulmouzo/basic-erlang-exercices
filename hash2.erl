-module(hash2).
-export([start/0, store/3, get/2, del/2, stop/1]). %Api
-export([init/0]).

%%%API

start() -> 
    spawn(?MODULE, init, []).

store(Hash, Key, Value) -> 
    Hash ! {store, Key, Value, self()}.

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
    process_flag(trap_exit, true), 
    loop([]).

loop(D) -> 
    receive 
        {store, NK, NV, From} -> 
            D2 = del_key(NK, D),
            link(From),
            loop([{NK, NV, From} | D2]);
        {get, K, From} -> 
            From ! find(K, D),
            loop(D);
        {del, KD} -> 
            loop(del_key(KD, D));
        {'EXIT', Pid, _} -> 
            loop(del_all_keys(D, Pid));
        stop -> 
            ok 
    end.


rem_key(_, [], _) -> 
    not_found;
rem_key(K,[{K,_,From} | T], Acc) -> 
    {ok , Acc ++ T, From}; 
rem_key(K,[{K2, V2, From}|T],Acc) -> 
    rem_key(K, T, [{K2,V2,From}|Acc]).%Saves in Acc all the elements previous to the one we want to delete.

del_key(K, D) -> 
    case rem_key(K, D, []) of 
        {ok, ND, From} -> 
            case lists:any(fun ({_,_,Pid}) ->
                                Pid == From end, ND) of 
                true -> %Pid (From) is in new dictionary 
                    ND;
                false -> % Delete the last element with Pid = From
                    unlink(From), 
                    ND
            end;
        not_found -> 
            D
    end. 

% Returns the dictionary without the elements with pid Pid
del_all_keys(D, Pid) -> 
    [{K, V, From} || {K, V, From} <- D, From /= Pid].


find(_, []) -> {hash_error, not_found};
find(K, [{K, V, _} | _]) -> {hash_ok, V};
find(K, [_ | T]) -> find(K, T).




