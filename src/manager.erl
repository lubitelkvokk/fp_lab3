-module(manager).
-export([spawn_manage_algorithm_io_process/4, manage_algorithm_io_process/4]).
% -import(interpolation_process, [store_point/2, interpolate_by_lagrange/2, interpolate_by_linear/2]).

spawn_manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step) ->
    spawn(?MODULE, manage_algorithm_io_process, [Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step]).

send_with_each_algorithm(_, _, [], _) ->
    ok;
send_with_each_algorithm(Pid_of_algorithm_proc, Point, [Algorithm | T], Step) ->
    case Algorithm of
        linear ->
            interpolation_process:interpolate_by_linear(Pid_of_algorithm_proc, Step);
        lagrange ->
            interpolation_process:interpolate_by_lagrange(
                Pid_of_algorithm_proc, Step
            );
        _ ->
            ok
    end,
    send_with_each_algorithm(Pid_of_algorithm_proc, Point, T, Step).

%% только принимает данные
manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step) ->
    receive
        {ok_linear_interpolate, Result} ->
            % io:format("Result of lagrange ~p~n", [Result]),
            output:output_data(Pid_of_output_proc, {ok_linear_interpolate, Result}),
            manage_algorithm_io_process(
                Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step
            );
        {ok_lagrange_interpolate, Result} ->
            output:output_data(Pid_of_output_proc, {ok_lagrange_interpolate, Result}),
            manage_algorithm_io_process(
                Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step
            );
        {interpolate, Point} ->
            interpolation_process:store_point(Pid_of_algorithm_proc, Point),
            send_with_each_algorithm(Pid_of_algorithm_proc, Point, Algorithms, Step),
            manage_algorithm_io_process(
                Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step
            );
        
        _ ->
            manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc, Algorithms, Step)
    end.
