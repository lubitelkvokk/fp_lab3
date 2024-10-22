-module(manager).
-export([spawn_manage_algorithm_io_process/3, manage_algorithm_io_process/3]).
% -import(interpolation_process, [store_point/2, interpolate_by_lagrange/2, interpolate_by_linear/2]).

spawn_manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_input_proc, Pid_of_output_proc) ->
    spawn(?MODULE, manage_algorithm_io_process, [Pid_of_algorithm_proc, Pid_of_input_proc, Pid_of_output_proc]).
%% только принимает данные 
manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_input_proc, Pid_of_output_proc) ->
    receive 
        {Pid_of_input_proc, Point} -> 
            interpolation_process:store_point(Pid_of_algorithm_proc, Point),
            Points = interpolation_process:interpolate_by_linear(Pid_of_algorithm_proc, 1),
            output:output_data(Pid_of_output_proc, Points),
            manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_input_proc, Pid_of_output_proc);
        _ ->
            manage_algorithm_io_process(Pid_of_algorithm_proc, Pid_of_input_proc, Pid_of_output_proc)
        end.
