-module(tree).
-export([start_node/0, add_child/2, height/1]).
-export([init_node/0]).

%% API
start_node() ->
    spawn(?MODULE, init_node, []).

add_child(Tree, Child_Tree) ->
    Tree ! {add_child, Child_Tree}.

height(Tree) ->
    Tree ! {height, self()},
    receive 
        {height_reply, H} -> H 
    end. 

%% Internal functions
init_node() ->
    node_loop([]).

node_loop(Children) ->
    receive
        {add_child, Child_Tree} ->
            node_loop(Children ++ [Child_Tree]);
        {height, From} -> 
            Ht = 1 + lists:foldl(fun(Hmax, T) -> 
                                    max(Hmax,height(T)) end, -1, Children),
            From ! {height_reply, Ht},
            node_loop(Children)
    end.