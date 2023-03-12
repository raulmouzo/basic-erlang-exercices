-module(store).
-export([start/0, store/2, get/2]).
-export([loop/1]).

%% API
start() -> 
    spawn(?MODULE, loop, [[]]).
store(S, P) -> 
    S ! {store, P}.

get(S, F) -> 
    S ! {get, F, self()},
    receive
        {get_reply, R} -> R 
    end.


%% Internal Functions
loop(PS) ->
    receive
        {store, P} -> 
            loop([P | PS]);
        {get, F, From} -> 
            case find(PS, F, []) of
                not_found -> 
                    From ! {get_reply,{error, no_product}},
                    loop(PS);
                {ok, P, N_ps} -> 
                    From ! {get_reply, {ok, P}},
                    loop(N_ps)
            end;
        _ -> loop(PS)
    end.

find([], _, _) -> not_found;
find([P | PS], F, Acc) ->
    case F(P) of
        true -> {ok, P, Acc++PS};
        _ -> find(PS, F, [P | Acc])
    end.

