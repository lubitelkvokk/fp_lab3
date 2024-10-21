-module(linear_interpolation).
-compile([debug_info]).
-export([find_polynom_L_x/2]).

find_polynom_L_x(X, Points) ->
    find_polynom_L_x(X, Points, length(Points), 0).

find_polynom_L_x(_, _, 0, Acc) ->
    Acc;
find_polynom_L_x(X, Points, Ptr, Acc) ->
    {X_i, Y_i}= lists:nth(Ptr, Points),
    find_polynom_L_x(X, Points, Ptr - 1, Acc + Y_i * linear_l_i(X, X_i, Points, 1)).

linear_l_i(_, _, [], Acc) ->
    Acc;
linear_l_i(X, X_j, [{X_j, _} | Points], Acc) ->
    linear_l_i(X, X_j, Points, Acc);
linear_l_i(X, X_i, [{X_j, _} | Points], Acc) ->
    linear_l_i(X, X_i, Points, Acc * ((X - X_j) / (X_i - X_j))).

