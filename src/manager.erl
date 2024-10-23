-module(manager).
-export([spawn_manage_algorithm_io_process/2, manage_algorithm_io_process/2]).
% -import(interpolation_process, [store_point/2, interpolate_by_lagrange/2, interpolate_by_linear/2]).

spawn_manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc) ->
    spawn(?MODULE, manage_algorithm_io_process, [Pid_of_algorithm_proc, Pid_of_output_proc]).
%% только принимает данные
manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc) ->
    receive
        {_, Point} ->
            interpolation_process:store_point(Pid_of_algorithm_proc, Point),
            Ans1 = interpolation_process:interpolate_by_linear(Pid_of_algorithm_proc, 1),
            Ans2 = interpolation_process:interpolate_by_lagrange(Pid_of_algorithm_proc, 1),
            if
                Ans1 =/= {not_enough_values_for_linear_interpolation} ->
                    output:output_data(Pid_of_output_proc, Ans1);
                true ->
                    ok
            end,
            if
                Ans2 =/= {not_enough_values_for_lagrange_interpolation} ->
                    output:output_data(Pid_of_output_proc, Ans2);
                true ->
                    ok
            end,
            manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc);
        _ ->
            manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_output_proc)
    end.
