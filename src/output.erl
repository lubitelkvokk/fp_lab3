-module(output).
-export([output_data/2, spawn_output_process/0, output_process/0]).
-include("interpolation.hrl").

-spec output_data(Pid :: pid(), Points :: points()) -> ok.

spawn_output_process() ->
    spawn(?MODULE, output_process, []).

output_process() ->
    receive
        {_, Data} ->
            {Type_of_interpolation, Points} = Data,
            case Type_of_interpolation of
                ok_linear_interpolate ->
                    io:format("~nLinear interpolation: ~n~s~n", [
                        string:join(
                            [io_lib:format("~.2f, ~.2f", tuple_to_list(Point)) || Point <- Points],
                            ""
                        )
                    ]);
                ok_lagrange_interpolate ->
                    io:format("~nLagrange interpolation: ~n~s~n", [
                        string:join(
                            [io_lib:format("~.2f, ~.2f", tuple_to_list(Point)) || Point <- Points],
                            ""
                        )
                    ]);
                _ ->
                    io:format("~nUndefined type of interpolation")
            end,
            output_process();
        _ ->
            io:format("Incorrect data format")
    end.

output_data(Pid, Data) ->
    Pid ! {self(), Data},
    ok.
