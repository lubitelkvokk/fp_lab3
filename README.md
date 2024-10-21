lab3
=====

An escript

Build
-----

    $ rebar3 escriptize

Run
---

    $ _build/default/bin/lab3


Pid = interpolation_process:spawn_process_point([{0, 0}, {1.571, 1}, {3.142, 0}, {4.712, -1}, {12.568, 0}]).
interpolation_process:interpolate(Pid, 1).