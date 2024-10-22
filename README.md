lab3
=====

An escript

Build
-----

    $ rebar3 escriptize

Run
---

    $ _build/default/bin/lab3

<!-- Points = [{0, 0}, {1.571, 1}, {3.142, 0}, {4.712, -1}, {12.568, 0}]. -->
Points = [{0, 0}, {1.571, 1}].
Pid_process_point = interpolation_process:spawn_process_point(Points).
Pid_output = output:spawn_output_process().
output:output_data(Pid_output, [124, 325, 325]).
Pid_manager = manager:spawn_manage_algorithm_io_process(Pid_process_point, self(), Pid_output).
Pid_manager ! {self(), {3.142, 0}}.
interpolation_process:interpolate_by_linear(Pid_process_point, 1).

interpolation_process:store_point(Pid_process_point, {4, 0}).      