-module(interpolation_process).
-import(interpolation, [
    get_list_of_interpolation_points/2, get_list_of_linear_interpolation_points/2
]).
-export([
    spawn_process_point/1,
    process_point/1,
    store_point/2,
    interpolate_by_lagrange/2,
    interpolate_by_linear/2
]).

spawn_process_point(InitialPoints) ->
    spawn(?MODULE, process_point, [InitialPoints]).

store_point(Pid, Point) ->
    Pid ! {self(), {store, Point}},
    receive
        Msg -> Msg
    end.

interpolate_by_lagrange(Pid, Step) ->
    Pid ! {self(), {lagrange_interpolate, Step}},
    receive
        Msg -> Msg
    end.

interpolate_by_linear(Pid, Step) ->
    Pid ! {self(), {linear_interpolate, Step}},
    receive
        Msg -> Msg
    end.

process_point(Points) ->
    receive
        {From, {store, {X, Y}}} ->
            From ! {self(), {ok, successfull_storing}},
            process_point([{X, Y} | Points]);
        {From, {lagrange_interpolate, Step}} ->
            From ! {self(), {ok, get_list_of_interpolation_points(Points, Step)}},
            process_point(Points);
        {From, {linear_interpolate, Step}} ->
            From ! {self(), {ok, get_list_of_linear_interpolation_points(Points, Step)}},
            process_point(Points);
        {From, _} ->
            From ! {unexpected},
            process_point(Points);
        _ ->
            process_point(Points)
    end.
