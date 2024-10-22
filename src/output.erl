-module(output).
-export([output_data/2, spawn_output_process/0, output_process/0]).
-include("interpolation.hrl").

-spec output_data(Pid::pid(), Points::points()) -> ok.

spawn_output_process() ->
    spawn(?MODULE, output_process, []).

output_process() ->
    receive
        {_, Data} ->
            io:format("Received data: ~p~n", [Data]), 
            output_process();
        _ ->
            io:format("Incorrect data format")
    end.

output_data(Pid, Data) ->
    Pid ! {self(), Data},
    ok.
