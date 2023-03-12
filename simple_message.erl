-module(simple_message).
-export([start/0, process_b/0]).

start() ->
    Pid = spawn_link(?MODULE, process_b, []),
    Pid ! "hello from process A",
    io:format("Send message from process A.~n").

process_b() ->
    receive
        Message ->
            io:format("Received message on process B: ~p~n", [Message])
    end.
