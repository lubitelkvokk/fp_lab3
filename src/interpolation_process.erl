-module(interpolation_process).
-import(linear_interpolation, [get_list_of_interpolation_points/2]).
-export([spawn_process_point/1, process_point/1, store_point/2, interpolate/2]).

spawn_process_point(InitialPoints) ->
    spawn(?MODULE, process_point, [InitialPoints]).

store_point(Pid, Point) ->
    Pid ! {self(), {store, Point}},
    receive
        Msg -> Msg
    end.

interpolate(Pid, Step) ->
    Pid ! {self(), {interpolate, Step}},
    receive
        Msg -> Msg
    end.

process_point(Points) ->
    receive
        {From, {store, {X, Y}}} ->
            From ! {self(), {ok, successfull_storing}},
            process_point([{X, Y} | Points]);
        {From, {interpolate, Step}} ->
            From ! {self(), {ok, get_list_of_interpolation_points(Points, Step)}},
            process_point(Points);
        {From, _} ->
            From ! {unexpected},
            process_point(Points)
    end.
