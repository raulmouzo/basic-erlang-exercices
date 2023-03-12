-module(notifier).
-export([start/0, register/1, send/2]).
-export([loop/1]).

%% API

start() ->
    spawn(?MODULE, loop, [[]]).

register(N) -> 
    N ! {register, self()}. 

send(N, Msg) -> 
    N ! {send, Msg}.


%% Internal functions

loop(PS) -> 
    receive 
        {register, From} -> 
            loop([From | PS]);
        {send, Msg} -> 
            send_to_all(Msg, PS), % sends the msg to all processes of the list PS
            loop(PS)
    end. 
send_to_all(_, []) -> 
    ok;
send_to_all(Msg, [P | PS]) -> 
    P ! Msg, 
    send_to_all(Msg, PS).


%% Better implementation
%% send_to_all(Msg, PS) ->
%%     lists:foreach(fun(P) -> P ! Msg end, PS).

