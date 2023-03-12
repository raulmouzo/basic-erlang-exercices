-module(echo_server).
-export([start/0, init/0, echo/2]).

start() -> 
    spawn(echo_server, init, []).

echo(Echo_Srv, Msg) ->
    Echo_Srv ! {echo, Msg, self()},
    receive
        {echo_reply, Reply} ->
            Reply
end.

init() -> 
    loop().

loop() ->
    receive 
        stop -> %%stop echo server
            ok;
        {echo, Msg, From} -> %%send the reply to "From"
            From ! {echo_reply, Msg},
            loop()
    end.